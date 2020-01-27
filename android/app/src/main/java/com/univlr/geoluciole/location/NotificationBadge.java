package com.univlr.geoluciole.location;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.util.Log;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.univlr.geoluciole.MainActivity;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.badge.Badge;

import java.util.Objects;

public class NotificationBadge {
    private static final String CHANNEL_ID = "channelNotification";
    private static final String TAG = NotificationBadge.class.getSimpleName();

    /**
     * Méthode permettant d'afficher une notification si un badge est débloqué
     *
     * @param context Context
     * @param badge   Badge débloqué
     */
    public void showNotification(Context context, Badge badge) {
        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);
        // intent - redirige vers la MainActivity au clic sur la notification
        Intent notificationIntent = new Intent(context, MainActivity.class);
        notificationIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        PendingIntent pintent = PendingIntent.getActivity(context, Integer.parseInt(badge.getId()),
                notificationIntent, 0);
        int id = context.getResources().getIdentifier("notification_title", "string", context.getPackageName());
        String notificationTitle = context.getString(id);
        // construction de la notification
        NotificationCompat.Builder notifBuilder = new NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.mipmap.luciole_blanche)
                .setColor(context.getResources().getColor(R.color.colorPrimaryDark))
                .setContentTitle(notificationTitle)
                .setContentText(badge.getDescription())
                .setContentIntent(pintent)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);

        // creation de la notification
        Notification notification = notifBuilder.build();
        // si on tape sur la notif elle s'efface
        notification.flags |= Notification.FLAG_AUTO_CANCEL;
        notificationManager.notify(Integer.parseInt(badge.getId()), notification);
        Log.i(TAG, "showNotification, badge : " + badge.getName());
    }

    /**
     * Méthode permettant de créer le channel des notifications
     *
     * @param context Context
     */
    private void createNotificationChannel(Context context) {
        // Créer le NotificationChannel, seulement pour API 26+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "Notification badge channel";
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, importance);
            channel.setDescription("Channel pour pouvoir afficher les badges débloqués");
            // Enregister le canal sur le système : attention de ne plus rien modifier après
            NotificationManager notificationManager = context.getSystemService(NotificationManager.class);
            Objects.requireNonNull(notificationManager).createNotificationChannel(channel);
        }
    }
}
