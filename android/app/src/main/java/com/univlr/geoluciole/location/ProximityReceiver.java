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

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.location.LocationManager;
import android.util.Log;

import com.univlr.geoluciole.model.UserPreferences;
import com.univlr.geoluciole.model.badge.Badge;
import com.univlr.geoluciole.model.badge.BadgeConstantes;
import com.univlr.geoluciole.model.badge.BadgeManager;

import java.util.Objects;

/**
 * Cette classe est appeler à chaque foi qu'on rentre dans la localisation d'un lieu de badge
 *
 * ce receiver est set dans la classe LocationUpdateService dans la méthode setProximityAlert()
 */
public class ProximityReceiver extends BroadcastReceiver {
    private static final String TAG = ProximityReceiver.class.getSimpleName();

    @Override
    public void onReceive(Context context, Intent intent) {
        // clé pour indiquer que l'utilisateur entre dans la zone
        String keyEntering = LocationManager.KEY_PROXIMITY_ENTERING;

        boolean entered = intent.getBooleanExtra(keyEntering, false);
        NotificationBadge notificationBadge = new NotificationBadge();

        // débloque le badge et affiche la notification si on est dans la zone
        if (entered) {
            try {
                notificationBadge.createNotificationChannel(context);
                UserPreferences userPref = UserPreferences.getInstance(context);
                String idBadgeUnlocked = Objects.requireNonNull(intent.getExtras()).getString(BadgeConstantes.ID);
                if (!userPref.getListUnlockedBadges().contains(idBadgeUnlocked)) {
                    // Call the Notification Service or anything else that you would like to do here
                    BadgeManager badgeManager = BadgeManager.getInstance(context);
                    // déblocage du badge
                    badgeManager.unlockBadgesPlace(idBadgeUnlocked, context);
                    Badge badge = badgeManager.getArrayBadges().get(idBadgeUnlocked);
                    // creation de la notification
                    if (badge != null) {
                        notificationBadge.showNotification(context, badge);
                    }
                }
            } catch (NullPointerException npe) {
                Log.w(TAG, "onReceive, nullpointer " + npe.getMessage());
            }
        }
    }


}





