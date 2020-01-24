package com.univlr.geoluciole.sender;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.work.Worker;
import androidx.work.WorkerParameters;

import com.univlr.geoluciole.model.Logger;
import com.univlr.geoluciole.model.UserPreferences;

public class PeriodicallyHttpWorker extends Worker {
    public static final int PERIODICALLY_CALL_HTTP_IN_HOUR = 4;
    public static final String PERIODICALLY_HTTP_WORKER_NAME = "periodicallyHttpWorker";
    private Context context;

    PeriodicallyHttpWorker(Context context, WorkerParameters params) {
        super(context, params);
        this.context = context;
    }

    @NonNull
    @Override
    public Result doWork() {
        Logger.logWorker("Worker started");
        UserPreferences userPreferences = UserPreferences.getInstance(context);
        if (userPreferences.isGpsConsent()) {
            Logger.logWorker("Worker synchronize data");
            HttpProvider.sendGps(context);
        } else {
            Logger.logWorker("Worker has not permission [need GPS consent]");
        }
        return Result.success();
    }
}
