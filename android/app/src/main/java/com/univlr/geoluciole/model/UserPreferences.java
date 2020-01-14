package com.univlr.geoluciole.model;

import android.content.Context;
import android.provider.Settings;

import static com.univlr.geoluciole.model.PreferencesManager.getSavedObjectFromPreference;
import static com.univlr.geoluciole.model.PreferencesManager.saveObjectToSharedPreference;


public class UserPreferences {
    public static final String USER_PREFERENCE_KEY = "userPreferenceKey";
    public static final String USER_PREFERENCE_FILENAME = "UserPreference";

    private String id;
    private boolean gpsConsent;
    private boolean accountConsent;
    private long validityDuration;
    private String language;


    public UserPreferences(boolean consent, long validityDuration, String language, Context context) {
        this.id = generateID(context);
        this.gpsConsent = false;
        this.accountConsent = false;
        this.validityDuration = validityDuration;
        this.language = language;

    }

    public static UserPreferences getInstance(Context context) {
        return getSavedObjectFromPreference(context, UserPreferences.USER_PREFERENCE_FILENAME, UserPreferences.USER_PREFERENCE_KEY, UserPreferences.class);
    }

    public static void storeInstance(Context context, UserPreferences u) {
        saveObjectToSharedPreference(context, UserPreferences.USER_PREFERENCE_FILENAME, UserPreferences.USER_PREFERENCE_KEY, u);
    }


    private String generateID(Context context) {
        String androidId = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
        System.out.println("Android ID " + androidId);
        String newID = Long.toString(androidId.hashCode()*-1);
        System.out.println("Android ID hashé et tronqué" + newID) ;
        return newID;
    }

    public boolean isGpsConsent() {
        return gpsConsent;
    }

    public boolean isAccountConsent() {
        return accountConsent;
    }

    public void setGpsConsent(boolean consent) {
        this.gpsConsent = consent;
    }

    public void setAccountConsent(boolean consent) {
        this.accountConsent = consent;
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
                ", gpsConsent=" + gpsConsent +
                ", accountConsent=" + accountConsent +
                ", validityDuration=" + validityDuration +
                ", language='" + language + '\'' +
                '}';
    }
}
