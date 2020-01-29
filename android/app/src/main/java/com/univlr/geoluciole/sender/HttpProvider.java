/*
 * Copyright (c) 2020, La Rochelle Université
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *  Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *  Neither the name of the University of California, Berkeley nor the
 *   names of its contributors may be used to endorse or promote products
 *   derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package com.univlr.geoluciole.sender;

import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import androidx.concurrent.futures.CallbackToFutureAdapter;
import androidx.work.Constraints;
import androidx.work.ExistingPeriodicWorkPolicy;
import androidx.work.ListenableWorker;
import androidx.work.NetworkType;
import androidx.work.PeriodicWorkRequest;
import androidx.work.WorkManager;

import com.google.common.util.concurrent.ListenableFuture;
import com.univlr.geoluciole.database.LocationTable;
import com.univlr.geoluciole.model.FormModel;
import com.univlr.geoluciole.model.Logger;
import com.univlr.geoluciole.model.UserPreferences;

import org.json.JSONObject;

import java.io.IOException;
import java.util.concurrent.Executor;
import java.util.concurrent.TimeUnit;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Response;

public class HttpProvider {
    //private final static String BASE_URL = "https://datamuseum.univ-lr.fr:9200/";
    private final static String BASE_URL = "http://datamuseum.univ-lr.fr:9200/";
    // private final static String BASE_URL = "http://86.233.189.163:9200/";

    public final static int CODE_HANDLER_GPS_COUNT = 1;
    public final static int CODE_HANDLER_GPS_ERROR = 2;
    public final static int CODE_HANDLER_GPS_NO_DATA = 3;

    public final static String GPS_URL = BASE_URL + "da3t_gps/_doc/_bulk";
    public final static String ACCOUNT_URL = BASE_URL + "da3t_compte/_doc/<id>";
    public final static String FORM_URL = BASE_URL + "da3t_formulaire/_doc/_bulk";

    public static void sendForm(final Context context) {
        FormModel form = FormModel.getInstance(context);
        if (form != null) {
            sendForm(context, form);
        }
    }

    public static void activePeriodicSend(Context context) {
        // récupération du workerManager
        WorkManager workManager = WorkManager.getInstance(context);
        // création des constraintes
        Constraints constraintsNetwork = new Constraints.Builder().setRequiredNetworkType(NetworkType.CONNECTED).build();
        // création de la request


        PeriodicWorkRequest periodicWorkRequest =  new PeriodicWorkRequest.Builder(
                PeriodicallyHttpWorker.class, 15, TimeUnit.MINUTES) // todo ligne de test
        //        PeriodicallyHttpWorker.class, PeriodicallyHttpWorker.PERIODICALLY_CALL_HTTP_IN_HOUR, TimeUnit.HOURS) //todo décommenter cette ligne (ligne de prod)
                .setConstraints(constraintsNetwork)
                .build();
        // Mise en place du periodique worker
        Logger.logWorker("Creation worker request");
        workManager.enqueueUniquePeriodicWork(PeriodicallyHttpWorker.PERIODICALLY_HTTP_WORKER_NAME, ExistingPeriodicWorkPolicy.KEEP, periodicWorkRequest);
    }

    public static void cancelPeriodicSend(Context context) {
        WorkManager workManager = WorkManager.getInstance(context);
        ListenableFuture listenableFuture = workManager.cancelUniqueWork(PeriodicallyHttpWorker.PERIODICALLY_HTTP_WORKER_NAME).getResult();
        listenableFuture.addListener(new Runnable() {
            @Override
            public void run() {
                Logger.logWorker("Gps worker cancel");
            }
        }, new Executor() {
            @Override
            public void execute(Runnable runnable) {
                runnable.run();
            }
        });
    }

    public static void sendForm(final Context context, FormModel form) {
        final UserPreferences userPreferences = UserPreferences.getInstance(context);
        new HttpSender()
                .setData(HttpSender.parseDataInBulk(form))
                .setUrl(FORM_URL)
                .setCallback(new Callback() {
                    @Override
                    public void onFailure(Call call, IOException e) {
                        Logger.logForm(e);
                    }

                    @Override
                    public void onResponse(Call call, Response response) throws IOException {
                        String responseBody = response.body().string();
                        try {
                            // recuperation du status de l'insertion
                            JSONObject jsonObject = new JSONObject(responseBody);
                            if (!jsonObject.getBoolean("errors")) {
                                Logger.logForm("form send");
                                userPreferences.setFormIsSend(true);
                                userPreferences.store(context);
                            } else {
                                Logger.logForm(jsonObject.toString(), Log.ERROR);
                            }
                        } catch (Exception ie) {
                            ie.printStackTrace();
                        }
                    }
                })
                .send();
    }

    public static void sendGps(Context context) {
        sendGps(context, null);
    }

    /**
     * Function appeler par la tâche périodique pour envoyer les données gps
     * @param context
     * @param completer
     */
    public static Callback sendGPsPeriodically(Context context, final CallbackToFutureAdapter.Completer<ListenableWorker.Result> completer) {
        final LocationTable locationTable = new LocationTable(context);
        final long count = locationTable.countAll();
        if (count == 0) {
            completer.set(ListenableWorker.Result.success());
            return null;
        }

        Callback callback = new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                Logger.logGps(e);
                completer.setException(e);
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                String responseBody = response.body().string();
                if (jsonSuccessAction(responseBody, count, Logger.TAG_GPS_PERIODICALLY)) {
                    locationTable.removeAll();
                }
                completer.set(ListenableWorker.Result.success());
            }
        };

        new HttpSender()
                .setData(HttpSender.parseDataInBulk(locationTable.getAll()))
                .setUrl(GPS_URL)
                .setCallback(callback)
                .send();

        return callback;
    }

    private static boolean jsonSuccessAction(String body, long count) {
        return jsonSuccessAction(body, count, Logger.TAG_GPS);
    }

    private static boolean jsonSuccessAction(String body, long count, String labelCustom) {
        try {
            JSONObject jsonObject = new JSONObject(body);
            if (!jsonObject.getBoolean("errors")) {
                Logger.log("GPS send data : "+ count + " locations", Log.INFO, labelCustom);
                return true;
            } else {
                Logger.log(jsonObject.toString(), Log.ERROR, labelCustom);
                return false;
            }
        } catch (Exception ie) {
            Logger.logGps(ie);
        }
        return false;
    }

    public static void sendGps(Context context, final Handler handler) {
        final LocationTable locationTable = new LocationTable(context);
        final long count = locationTable.countAll();
        if (count == 0) {
            if (handler != null) {
                Message message = handler.obtainMessage(CODE_HANDLER_GPS_NO_DATA);
                message.sendToTarget();
            }
            return;
        }
        new HttpSender()
                .setData(HttpSender.parseDataInBulk(locationTable.getAll()))
                .setUrl(GPS_URL)
                .setCallback(new Callback() {
                    @Override
                    public void onFailure(Call call, IOException e) {
                        Logger.logGps(e);
                        if (handler != null) {
                            Message message = handler.obtainMessage(CODE_HANDLER_GPS_ERROR);
                            message.sendToTarget();
                        }
                    }

                    @Override
                    public void onResponse(Call call, Response response) throws IOException {
                        if (handler != null) {
                            Message message = handler.obtainMessage(CODE_HANDLER_GPS_COUNT, count);
                            message.sendToTarget();
                        }
                        String responseBody = response.body().string();
                        if (jsonSuccessAction(responseBody, count)) {
                            locationTable.removeAll();
                        }
                    }
                })
                .send();
    }

    public static void sendAccount(final Context context, String content) {
        final UserPreferences userPreferences = UserPreferences.getInstance(context);
        String url = ACCOUNT_URL.replace("<id>", userPreferences.getId());
        new HttpSender()
                .setData(content)
                .setUrl(url)
                .setCallback(new Callback() {
                    @Override
                    public void onFailure(Call call, IOException e) {
                        Logger.logAccount(e);
                    }

                    @Override
                    public void onResponse(Call call, Response response) throws IOException {
                        String responseBody = response.body().string();
                        try {
                            JSONObject jsonObject = new JSONObject(responseBody);
                            if (response.code() == 200) {
                                Logger.logAccount("account send");
                                userPreferences.setAccountIsSend(true);
                                userPreferences.store(context);
                            } else {
                                Logger.logAccount(jsonObject.toString(), Log.ERROR);
                            }
                        } catch (Exception ie) {
                            ie.printStackTrace();
                        }
                    }
                })
                .send();
    }
}