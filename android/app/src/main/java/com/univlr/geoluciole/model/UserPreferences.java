package com.univlr.geoluciole.model;

import android.content.Context;
import android.provider.Settings;

import java.util.Locale;

import static com.univlr.geoluciole.model.PreferencesManager.getSavedObjectFromPreference;
import static com.univlr.geoluciole.model.PreferencesManager.saveObjectToSharedPreference;


public class UserPreferences {
    public static final String USER_PREFERENCE_KEY = "userPreferenceKey";
    public static final String USER_PREFERENCE_FILENAME = "UserPreference";

    private String id;
    private boolean consent;
    private boolean gpsConsent;
    private boolean accountConsent;
    private long validityDuration;
    private String language;


    public UserPreferences(String language, Context context) {
        this.id = generateID(context);
        this.consent = false;
        this.gpsConsent = false;
        this.accountConsent = false;
        this.validityDuration = 0;
        this.language = language;

    }

    public static UserPreferences getInstance(Context context) {
        UserPreferences userPreferences =  getSavedObjectFromPreference(context, UserPreferences.USER_PREFERENCE_FILENAME, UserPreferences.USER_PREFERENCE_KEY, UserPreferences.class);
        if (userPreferences == null) {
            String lang = Locale.getDefault().getDisplayLanguage();
            userPreferences = new UserPreferences(lang, context);
        }
        return userPreferences;
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

    public boolean hasGiveConsent() {
        return this.consent;
    }

    public boolean isGpsConsent() {
        return gpsConsent;
    }

    public boolean isAccountConsent() {
        return accountConsent;
    }

    public void setGpsConsent(boolean consent) {
        this.gpsConsent = consent;
        this.consent = true;
    }

    public void setAccountConsent(boolean consent) {
        this.accountConsent = consent;
        this.consent = true;
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
                ", consent=" + consent+
                ", gpsConsent=" + gpsConsent +
                ", accountConsent=" + accountConsent +
                ", validityDuration=" + validityDuration +
                ", language='" + language + '\'' +
                '}';
    }
}
