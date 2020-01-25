package com.univlr.geoluciole.location;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.location.LocationManager;

import android.widget.Toast;

import com.univlr.geoluciole.model.UserPreferences;
import com.univlr.geoluciole.model.badge.Badge;
import com.univlr.geoluciole.model.badge.BadgeManager;


public class ProximityReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        // The reciever gets the Context & the Intent that fired the broadcast as arg0 & agr1

        String keyEntering = LocationManager.KEY_PROXIMITY_ENTERING;
        // Key for determining whether user is leaving or entering

        boolean entered = intent.getBooleanExtra(keyEntering, false);
        NotificationBadge notificationBadge = new NotificationBadge();

        //Gives whether the user is entering or leaving in boolean form

        if (entered) {
            UserPreferences userPref = UserPreferences.getInstance(context);
            String idBadgeUnlocked = intent.getExtras().getString("idBadge");
            if (!userPref.getListUnlockedBadges().contains(idBadgeUnlocked)) {
                // Call the Notification Service or anything else that you would like to do here
                BadgeManager badgeManager = BadgeManager.getInstance(context);
                badgeManager.unlockBadgesPlace(idBadgeUnlocked, context);
                Badge badge = badgeManager.getArrayBadges().get(idBadgeUnlocked);
                Toast.makeText(context, "Welcome to my Area, unlock badge id : " + idBadgeUnlocked, Toast.LENGTH_LONG).show();
                // creation de la notification
                notificationBadge.showNotification(context, badge);
            }
        } else {
            //Other custom Notification
            Toast.makeText(context, "Thank you for visiting my Area,come back again !!", Toast.LENGTH_LONG).show();
        }

    }


}





