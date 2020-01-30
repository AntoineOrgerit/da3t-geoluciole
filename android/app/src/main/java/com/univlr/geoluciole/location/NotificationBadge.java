/*
 * Copyright (c) 2020, Martin Allusse and Alexandre Baret and Jessy Barritault and Florian
 * Bertonnier and Lisa Fougeron and François Gréau and Thibaud Lambert and Antoine
 * Orgerit and Laurent Rayez
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

import com.univlr.geoluciole.R;
import com.univlr.geoluciole.model.badge.Badge;
import com.univlr.geoluciole.ui.MainActivity;

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
    public void createNotificationChannel(Context context) {
        // Créer le NotificationChannel, seulement pour API 26+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "Notification badge channel";
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, importance);
            channel.setDescription("Channel pour pouvoir afficher les badges débloqués");
            // Enregister le canal sur le système : attention de ne plus rien modifier après
            NotificationManager notificationManager = context.getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }
}
