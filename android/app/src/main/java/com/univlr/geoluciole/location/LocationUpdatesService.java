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

/**
 * Modifications done:
 *  - update of package name and string value of PACKAGE_NAME variable;
 *  - update notification channel name;
 *  - remove stopping activity from notifications;
 *  - adapting to Android 8 and 9 versions;
 *  - update of Location retrieve system.
 */

package com.univlr.geoluciole.location;

import android.app.ActivityManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Configuration;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Binder;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import android.os.Looper;
import android.util.Log;

import androidx.core.app.NotificationCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.google.android.gms.location.LocationRequest;
import com.univlr.geoluciole.MainActivity;
import com.univlr.geoluciole.R;
import com.univlr.geoluciole.database.LocationTable;
import com.univlr.geoluciole.model.UserPreferences;
import com.univlr.geoluciole.model.badge.Badge;
import com.univlr.geoluciole.model.badge.BadgeConstantes;
import com.univlr.geoluciole.model.badge.BadgeManager;
import com.univlr.geoluciole.model.badge.BadgePlace;

import java.math.BigDecimal;
import java.math.MathContext;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * A bound and started service that is promoted to a foreground service when location updates have
 * been requested and all clients unbind.
 *
 * For apps running in the background on "O" devices, location is computed only once every 10
 * minutes and delivered batched every 30 minutes. This restriction applies even to apps
 * targeting "N" or lower which are run on "O" devices.
 *
 * This sample show how to use a long-running service for location updates. When an activity is
 * bound to this service, frequent location updates are permitted. When the activity is removed
 * from the foreground, the service promotes itself to a foreground service, and location updates
 * continue. When the activity comes back to the foreground, the foreground service stops, and the
 * notification assocaited with that service is removed.
 */
public class LocationUpdatesService extends Service {

    private static final String PACKAGE_NAME =
            "com.univlr.geoluciole.location";

    private static final String TAG = LocationUpdatesService.class.getSimpleName();

    /**
     * The name of the channel for notifications.
     */
    private static final String CHANNEL_ID = "channel_location_updates_service";

    public static final String ACTION_BROADCAST = PACKAGE_NAME + ".broadcast";

    public static final String EXTRA_LOCATION = PACKAGE_NAME + ".location";
    private static final String EXTRA_STARTED_FROM_NOTIFICATION = PACKAGE_NAME +
            ".started_from_notification";
    private static final String COM_UNIVLR_GEOLUCIOLE_PROXIMITYALERT = "com.univlr.geoluciole.proximityalert";

    private final IBinder mBinder = new LocalBinder();

    /**
     * The desired interval for location updates. Inexact. Updates may be more or less frequent.
     */
    private static final long UPDATE_INTERVAL_IN_MILLISECONDS = 10000;

    /**
     * The fastest rate for active location updates. Updates will never be more frequent
     * than this value.
     */
    private static final long FASTEST_UPDATE_INTERVAL_IN_MILLISECONDS =
            UPDATE_INTERVAL_IN_MILLISECONDS / 2;

    /**
     * The identifier for the notification displayed for the foreground service.
     */
    private static final int NOTIFICATION_ID = 12345678;

    /**
     * Used to check whether the bound activity has really gone away and not unbound as part of an
     * orientation change. We create a foreground service notification only if the former takes
     * place.
     */
    private boolean mChangingConfiguration = false;

    private NotificationManager mNotificationManager;

    /**
     * Contains parameters used by {@link com.google.android.gms.location.FusedLocationProviderApi}.
     */
    private LocationRequest mLocationRequest;

    private Handler mServiceHandler;

    private String filename;

    private LocationManager mLocationManager;
    private Criteria mCriteria;
    private LocationListener mLocationListener;
    private ProximityReceiver receiverAlertLocation;

    @Override
    public void onCreate() {
        mLocationManager = (LocationManager) this.getSystemService(LOCATION_SERVICE);
        mCriteria = new Criteria();
        mCriteria.setAccuracy(Criteria.ACCURACY_FINE);
        mCriteria.setHorizontalAccuracy(Criteria.ACCURACY_HIGH);
        mCriteria.setVerticalAccuracy(Criteria.ACCURACY_HIGH);
        mLocationListener = new LocationListener() {
            @Override
            public void onLocationChanged(Location location) {

                LocationTable locationTable = new LocationTable(LocationUpdatesService.this);
                // récuperation de la dernière distance pour le calcul de distance
                Location last = locationTable.getLastLocation();
                if(last.getTime() != 0) {
                    float distance = last.distanceTo(location);
                    long deltaT = Math.abs(location.getTime() - last.getTime()) / 1000;
                    // définition de l'arrondi
                    BigDecimal speed = new BigDecimal(location.getSpeed()).round(new MathContext(1));
                    if (speed != null && speed.compareTo(BigDecimal.ZERO) > 0) {

                        // on recupère pas l'instance si pas nécessaire
                        UserPreferences userPreferences = UserPreferences.getInstance(LocationUpdatesService.this);
                        BadgeManager badgeManager = BadgeManager.getInstance(LocationUpdatesService.this);

                        // si la distance mesurée et calculée sont cohérentes on ajoute la distance sinon on prend la valeur estimée par rapport a la vitesse
                        if (distance <= (speed.doubleValue() * deltaT) + 10) {
                            userPreferences.setDistance(userPreferences.getDistance() + distance);
                        } else {
                            userPreferences.setDistance(userPreferences.getDistance() + (speed.floatValue() * deltaT) + 10);
                        }
                        //update userPref
                        userPreferences.store(LocationUpdatesService.this);

                        // verification si badge distance debloqué
                        badgeManager.unlockBadgesDistance(LocationUpdatesService.this);
                    }
                }
                // insertion de la nouvelle valeur en bdd
                locationTable.insert(location);
                onNewLocation(location);
            }

            @Override
            public void onStatusChanged(String provider, int status, Bundle extras) {
                Log.i(TAG, "onStatusChanger: " + provider + " " + status + " " + extras.toString());
            }

            @Override
            public void onProviderEnabled(String provider) {
                Log.i(TAG, "onProviderEnabled: " + provider);
            }

            @Override
            public void onProviderDisabled(String provider) {
                Log.i(TAG, "onProviderDisabled: " + provider);
            }
        };


        HandlerThread handlerThread = new HandlerThread(TAG);
        handlerThread.start();
        mServiceHandler = new Handler(handlerThread.getLooper());
        mNotificationManager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);

        // Android O requires a Notification Channel.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = getString(R.string.app_name);
            // Create the channel for the notification
            NotificationChannel mChannel =
                    new NotificationChannel(CHANNEL_ID, name, NotificationManager.IMPORTANCE_DEFAULT);

            // Set the Notification Channel for the Notification Manager.
            mNotificationManager.createNotificationChannel(mChannel);
        }
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.i(TAG, "Service started");
        Runnable r = new Runnable() {
            @Override
            public void run() {
                setProximity(); // instanciation des alertes de proximités
            }
        };
        Thread t = new Thread(r);
        t.start();
        // Tells the system to not try to recreate the service after it has been killed.
        return START_STICKY;
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        mChangingConfiguration = true;
    }

    @Override
    public IBinder onBind(Intent intent) {
        // Called when a client (MainActivity in case of this sample) comes to the foreground
        // and binds with this service. The service should cease to be a foreground service
        // when that happens.
        Log.i(TAG, "in onBind()");
        stopForeground(true);
        mChangingConfiguration = false;
        return mBinder;
    }

    @Override
    public void onRebind(Intent intent) {
        // Called when a client (MainActivity in case of this sample) returns to the foreground
        // and binds once again with this service. The service should cease to be a foreground
        // service when that happens.
        Log.i(TAG, "in onRebind()");
        stopForeground(true);
        mChangingConfiguration = false;
        super.onRebind(intent);
    }

    @Override
    public boolean onUnbind(Intent intent) {
        Log.i(TAG, "Last client unbound from service");

        // Called when the last client (MainActivity in case of this sample) unbinds from this
        // service. If this method is called due to a configuration change in MainActivity, we
        // do nothing. Otherwise, we make this service a foreground service.
        if (!mChangingConfiguration && Utils.requestingLocationUpdates(this)) {
            Log.i(TAG, "Starting foreground service");

            startForeground(NOTIFICATION_ID, getNotification());
        }
        return true; // Ensures onRebind() is called when a client re-binds.
    }

    @Override
    public void onDestroy() {
        mServiceHandler.removeCallbacksAndMessages(null);
    }

    /**
     * Makes a request for location updates. Note that in this sample we merely log the
     * {@link SecurityException}.
     */
    public void requestLocationUpdates() {
        Log.i(TAG, "Requesting location updates");
        Utils.setRequestingLocationUpdates(this, true);
        // permet de garder le service active même après la fin de l'application
        startService(new Intent(getApplicationContext(), LocationUpdatesService.class));
        try {
            mLocationManager.requestLocationUpdates(2000, 10, mCriteria, mLocationListener, Looper.myLooper());
        } catch (SecurityException unlikely) {
            Utils.setRequestingLocationUpdates(this, false);
            Log.e(TAG, "Lost location permission. Could not request updates. " + unlikely);
        }
    }

    /**
     * Removes location updates. Note that in this sample we merely log the
     * {@link SecurityException}.
     */
    public void removeLocationUpdates() {
        Log.i(TAG, "Removing location updates");
        try {
            mLocationManager.removeUpdates(mLocationListener);
            Utils.setRequestingLocationUpdates(this, false);
            stopSelf();
        } catch (SecurityException unlikely) {
            Utils.setRequestingLocationUpdates(this, true);
            Log.e(TAG, "Lost location permission. Could not remove updates. " + unlikely);
        }
    }

    /**
     * Returns the {@link NotificationCompat} used as part of the foreground service.
     */
    private Notification getNotification() {
        CharSequence text = getResources().getString(R.string.location_notification_content_text);

        // The PendingIntent to launch activity.
        PendingIntent activityPendingIntent = PendingIntent.getActivity(this, 0,
                new Intent(this, MainActivity.class), 0);

        if (Build.VERSION.SDK_INT >= 26) {
            String CHANNEL_ID = "my_channel_01";
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID,
                    "Channel human readable title",
                    NotificationManager.IMPORTANCE_DEFAULT);

            ((NotificationManager) Objects.requireNonNull(getSystemService(Context.NOTIFICATION_SERVICE))).createNotificationChannel(channel);
        }

        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, CHANNEL_ID)
                .addAction(R.drawable.ic_home_black_24dp, getResources().getString(R.string.location_notification_button_text), activityPendingIntent)
                .setContentText(text)
                .setContentTitle(getResources().getString(R.string.location_notification_content_title))
                .setOngoing(true)
                .setPriority(Notification.PRIORITY_HIGH)
                .setSmallIcon(R.mipmap.luciole_blanche)
                .setTicker(text)
                .setWhen(System.currentTimeMillis());

        return builder.build();
    }

    private void onNewLocation(Location location) {
        Log.i(TAG, "New location: " + location);

        /**
         * The current location.
         */

        // Notify anyone listening for broadcasts about the new location.
        Intent intent = new Intent(ACTION_BROADCAST);
        intent.putExtra(EXTRA_LOCATION, location);
        LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(intent);

        // Update notification content if running as a foreground service.
        if (serviceIsRunningInForeground(this)) {
            mNotificationManager.notify(NOTIFICATION_ID, getNotification());
        }
    }

    /**
     * Class used for the client Binder.  Since this service runs in the same process as its
     * clients, we don't need to deal with IPC.
     */
    public class LocalBinder extends Binder {
        public LocationUpdatesService getService() {
            return LocationUpdatesService.this;
        }
    }

    /**
     * Returns true if this is a foreground service.
     *
     * @param context The {@link Context}.
     */
    public boolean serviceIsRunningInForeground(Context context) {
        ActivityManager manager = (ActivityManager) context.getSystemService(
                Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : Objects.requireNonNull(manager).getRunningServices(
                Integer.MAX_VALUE)) {
            if (getClass().getName().equals(service.service.getClassName()) && service.foreground) {
                return true;
            }
        }
        return false;
    }

    /**
     * Méthode permettant de créer les alertes de proximité en fonction de chaque badge à débloquer
     */
    private void setProximity() {
        Utils.setRequestingLocationUpdates(this, true);
        BadgeManager badgeManager = BadgeManager.getInstance(LocationUpdatesService.this);
        HashMap<String, Badge> listeBagdeLock = badgeManager.cleanListBadge(this);
        this.instanciateProximityReceiver();
        try {
            for (Map.Entry<String, Badge> entry : listeBagdeLock.entrySet()) {
                String key = entry.getKey();
                int id = Integer.parseInt(key);
                Badge b = entry.getValue();
                Intent i = new Intent(COM_UNIVLR_GEOLUCIOLE_PROXIMITYALERT);
                if (b instanceof BadgePlace) {
                    i.putExtra(BadgeConstantes.ID, key);
                    PendingIntent pi = PendingIntent.getBroadcast(getApplicationContext(), id, i, PendingIntent.FLAG_UPDATE_CURRENT);
                    double latitude = ((BadgePlace) b).getLocation().getLatitude();
                    double longitude = ((BadgePlace) b).getLocation().getLongitude();
                    float proximity = (float) ((BadgePlace) b).getProximity();
                    mLocationManager.addProximityAlert(latitude, longitude, proximity, -1, pi);
                    Log.i(TAG, "setProximity, alertProximity ajoutée : latitude : " + latitude + ", longitude : " + longitude + ", proximity : " + proximity);
                }
            }
        } catch (SecurityException unlikely) {
            Utils.setRequestingLocationUpdates(this, false);
            Log.e(TAG, "Lost location permission. Could not request updates. " + unlikely);
        }
    }

    /**
     * Méthode pour instancier le receveur pour les alertes de proximité
     */
    private void instanciateProximityReceiver() {
        IntentFilter filter = new IntentFilter(COM_UNIVLR_GEOLUCIOLE_PROXIMITYALERT);
        receiverAlertLocation = new ProximityReceiver();
        registerReceiver(receiverAlertLocation, filter);
    }

    public void stopService() {
        if (receiverAlertLocation != null) {
            try {
                unregisterReceiver(receiverAlertLocation);
            } catch (IllegalArgumentException iae) {
                //do nothing
            }
        }
        this.removeLocationUpdates();
        this.stopSelf();
    }
}