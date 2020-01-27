package com.univlr.geoluciole.sender;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.concurrent.futures.CallbackToFutureAdapter;
import androidx.work.ListenableWorker;
import androidx.work.WorkerParameters;

import com.google.common.util.concurrent.ListenableFuture;
import com.univlr.geoluciole.model.Logger;

public class PeriodicallyHttpWorker extends ListenableWorker {
    public static final int PERIODICALLY_CALL_HTTP_IN_HOUR = 4;
    public static final String PERIODICALLY_HTTP_WORKER_NAME = "periodicallyHttpWorker";
    private Context context;

    public PeriodicallyHttpWorker(Context context, WorkerParameters params) {
        super(context, params);
        this.context = context;
    }

    @NonNull
    @Override
    public ListenableFuture<Result> startWork() {
        return CallbackToFutureAdapter.getFuture(new CallbackToFutureAdapter.Resolver<Result>() {
            @Nullable
            @Override
            public Object attachCompleter(@NonNull final CallbackToFutureAdapter.Completer<Result> completer) throws Exception {
                Logger.logWorker("Worker started");
                return HttpProvider.sendGPsPeriodically(context, completer);
            }
        });
    }

    @Override
    public void onStopped() {
        Logger.logWorker("Worker stopped");
        super.onStopped();
    }
}
