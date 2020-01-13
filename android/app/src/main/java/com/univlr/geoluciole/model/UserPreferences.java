package com.univlr.geoluciole.model;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.pm.PackageManager;
import android.provider.Settings;
import android.telephony.TelephonyManager;


public class UserPreferences {
    private String id;
    private boolean consent;
    private long validityDuration;
    private String language;


    public UserPreferences(boolean consent, long validityDuration, String language, Context context) {
        this.id = generateID(context);
        this.consent = false;
        this.validityDuration = validityDuration;
        this.language = language;

    }


    private String generateID(Context context) {
        String androidId = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
        System.out.println("Android ID " + androidId);
        String newID = Long.toString(androidId.hashCode()*-1);
        System.out.println("Android ID hashé et tronqué" + newID) ;
        return newID;
    }

    public boolean isConsent() {
        return consent;
    }

    public void setConsent(boolean consent) {
        this.consent = consent;
    }

    public long getValidityDuration() {
        return validityDuration;
    }

    public void setValidityDuration(long validityDuration) {
        this.validityDuration = validityDuration;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getId() {
        return id;
    }

    @Override
    public String toString() {
        return "UserPreferences{" +
                "id='" + id + '\'' +
                ", consent=" + consent +
                ", validityDuration=" + validityDuration +
                ", language='" + language + '\'' +
                '}';
    }
}
