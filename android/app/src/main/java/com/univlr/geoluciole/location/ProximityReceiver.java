package com.univlr.geoluciole.location;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.location.LocationManager;

import android.util.Log;
import android.widget.Toast;

import com.univlr.geoluciole.model.UserPreferences;
import com.univlr.geoluciole.model.badge.Badge;
import com.univlr.geoluciole.model.badge.BadgeConstantes;
import com.univlr.geoluciole.model.badge.BadgeManager;


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
                UserPreferences userPref = UserPreferences.getInstance(context);
                String idBadgeUnlocked = intent.getExtras().getString(BadgeConstantes.ID);
                if (!userPref.getListUnlockedBadges().contains(idBadgeUnlocked)) {
                    // Call the Notification Service or anything else that you would like to do here
                    BadgeManager badgeManager = BadgeManager.getInstance(context);
                    badgeManager.unlockBadgesPlace(idBadgeUnlocked, context);
                    Badge badge = badgeManager.getArrayBadges().get(idBadgeUnlocked);
                    Toast.makeText(context, "Welcome to my Area, unlock badge id : " + idBadgeUnlocked, Toast.LENGTH_LONG).show();
                    // creation de la notification
                    notificationBadge.showNotification(context, badge);
                }
            } catch (NullPointerException npe) {
                Log.w(TAG, "onReceive, nullpointer " + npe.getMessage());
            }
        }
    }


}





