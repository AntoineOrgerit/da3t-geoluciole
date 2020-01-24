package com.univlr.geoluciole.sender;

import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import com.univlr.geoluciole.database.LocationTable;
import com.univlr.geoluciole.model.FormModel;
import com.univlr.geoluciole.model.Logger;
import com.univlr.geoluciole.model.UserPreferences;

import org.json.JSONObject;

import java.io.IOException;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Response;

public class HttpProvider {
    private final static String BASE_URL = "http://datamuseum.univ-lr.fr:80/";

    public final static int CODE_HANDLER_GPS_COUNT = 1;
    public final static int CODE_HANDLER_GPS_ERROR = 2;

    public final static String GPS_URL = BASE_URL + "da3t_gps/_doc/_bulk";
    public final static String ACCOUNT_URL = BASE_URL + "da3t_compte/_doc/<id>";
    public final static String FORM_URL = BASE_URL + "da3t_formulaire/_doc/_bulk";

    public static void sendForm(final Context context) {
        FormModel form = FormModel.getInstance(context);
        if (form != null) {
            sendForm(context, form);
        }
    }

    public static void sendForm(final Context context, FormModel form) {
        final UserPreferences userPreferences = UserPreferences.getInstance(context);
        new HttpSender()
                .setData(HttpSender.parseDataInBulk(form))
                .setUrl(FORM_URL)
                .setCallback(new Callback() {
                    @Override
                    public void onFailure(Call call, IOException e) {
                        // todo logger
                    }

                    @Override
                    public void onResponse(Call call, Response response) throws IOException {
                        String responseBody = response.body().string();
                        try {
                            // recuperation du status de l'insertion
                            JSONObject jsonObject = new JSONObject(responseBody);
                            if (!jsonObject.getBoolean("errors")) {
                                userPreferences.setFormIsSend(true);
                                userPreferences.store(context);
                            } else {
                                // todo log les errors
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

    public static void sendGps(Context context, final Handler handler) {
        final LocationTable locationTable = new LocationTable(context);
        final long count = locationTable.countAll();
        if (count == 0) {
            return;
        }
        new HttpSender()
                .setData(HttpSender.parseDataInBulk(locationTable.getAll()))
                .setUrl(GPS_URL)
                .setCallback(new Callback() {
                    @Override
                    public void onFailure(Call call, IOException e) {
                        Logger.logGps(e);
                    }

                    @Override
                    public void onResponse(Call call, Response response) throws IOException {
                        if (handler != null) {
                            Message message = handler.obtainMessage(CODE_HANDLER_GPS_COUNT, count);
                            message.sendToTarget();
                        }
                        String responseBody = response.body().string();
                        try {
                            JSONObject jsonObject = new JSONObject(responseBody);
                            Logger.logGps(jsonObject);
                            if (!jsonObject.getBoolean("errors")) {
                                locationTable.removeAll();
                            } else {
                                Logger.logGps(jsonObject, Log.ERROR);
                            }
                        } catch (Exception ie) {
                            Logger.logGps(ie);
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
                        // todo logger
                    }

                    @Override
                    public void onResponse(Call call, Response response) throws IOException {
                        // todo logger
                        String responseBody = response.body().string();
                        try {
                            JSONObject jsonObject = new JSONObject(responseBody);
                            if (!jsonObject.getBoolean("errors")) {
                                userPreferences.setAccountIsSend(true);
                                userPreferences.store(context);
                            } else {
                                // todo log les errors
                            }
                        } catch (Exception ie) {
                            ie.printStackTrace();
                        }
                    }
                })
                .send();
    }
}