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
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
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

package com.univlr.geoluciole.model;

import android.content.Context;
import android.util.Log;

import com.hypertrack.hyperlog.HyperLog;
import com.hypertrack.hyperlog.LogFormat;

import org.json.JSONObject;

public class Logger extends HyperLog {
    public static final String TAG_GPS = "GPS_LOG";
    public static final String TAG_GPS_PERIODICALLY = "GPS_AUTO_LOG";
    public static final String TAG_FORM = "FORM_LOG";
    public static final String TAG_ACCOUNT = "ACCOUNT_LOG";
    public static final String TAG_WORKER = "WORKER_LOG";

    private static String user_id;
    private Logger() {}

    public static void init(Context context) {
        if (user_id == null) {
            user_id = UserPreferences.getInstance(context).getId();
        }
        initialize(context);
        setLogLevel(Log.VERBOSE);
        setLogFormat(new CustomLogFormat(context, user_id));
    }

    public static void log(String message, int flag, String tag) {
        switch (flag) {
            case Log.DEBUG:
                HyperLog.d(tag, message);
                break;
            case Log.INFO:
                HyperLog.i(tag, message);
                break;
            case Log.ERROR:
                HyperLog.e(tag, message);
        }
    }

    public static void logGps(String message, int flag) {
        log(message, flag, TAG_GPS);
    }


    public static void logGps(JSONObject response, int flag) {
        log(response.toString(), flag, TAG_GPS);
    }

    public static void logGps(String message) {
        HyperLog.i(TAG_GPS, message);
    }

    public static void logGps(Exception err) {
        HyperLog.e(TAG_GPS, err.getMessage());
    }

    public static void logForm(String message) {
        HyperLog.i(TAG_FORM, message);
    }

    public static void logForm(Exception e) {
        HyperLog.e(TAG_FORM, e.getMessage());
    }

    public static void logForm(String message, int flag) {
        Logger.log(message, flag, TAG_FORM);
    }

    public static void logAccount(String message) {
        HyperLog.i(TAG_ACCOUNT, message);
    }

    public static void logAccount(String message, int flag) {
        Logger.log(message, flag, TAG_ACCOUNT);
    }

    public static void logAccount(Exception e) {
        HyperLog.e(TAG_ACCOUNT, e.getMessage());
    }

    public static void logWorker(String message) {
        HyperLog.i(TAG_WORKER, message);
    }
}

class CustomLogFormat extends LogFormat {
    private final String user_id;
    public CustomLogFormat(Context context, String user_id) {
        super(context);
        this.user_id = user_id;
    }

    @Override
    public String getFormattedLogMessage(String logLevelName, String tag, String message, String timeStamp, String senderName, String osVersion, String deviceUUID) {
        return timeStamp + " | {" + user_id + "} | " + osVersion + " | " + deviceUUID + " | [" + logLevelName + " | " + tag + "]: " + message;
    }
}
