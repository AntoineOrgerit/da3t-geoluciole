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
    public static final String TAG_ACCOUNT = "FORM_LOG";
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
        // todo definir le message a recup
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
        log(message, flag, TAG_FORM);
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
    private String user_id;
    public CustomLogFormat(Context context, String user_id) {
        super(context);
        this.user_id = user_id;
    }

    @Override
    public String getFormattedLogMessage(String logLevelName, String tag, String message, String timeStamp, String senderName, String osVersion, String deviceUUID) {
        return timeStamp + " | {" + user_id + "} | " + osVersion + " | " + deviceUUID + " | [" + logLevelName + " | " + tag + "]: " + message;
    }
}
