package com.univlr.geoluciole.model;

import android.content.Context;
import android.provider.Settings;

import java.util.Date;
import java.util.Locale;

import static com.univlr.geoluciole.model.PreferencesManager.getSavedObjectFromPreference;
import static com.univlr.geoluciole.model.PreferencesManager.saveObjectToSharedPreference;


public class UserPreferences {
    private static final String USER_PREFERENCE_KEY = "userPreferenceKey";
    private static final String USER_PREFERENCE_FILENAME = "UserPreference";

    private String id;
    private boolean consent;
    private boolean gpsConsent;
    private long dateConsentementGPS;
    private long dateConsentementForm;
    private boolean accountConsent;
    private long startValidity;
    private long endValidity;
    private String language;

    private boolean isAccountIsSend;
    private boolean isFormIsSend;


    private UserPreferences(String language, Context context) {
        this.id = generateID(context);
        this.consent = false;
        this.gpsConsent = false;
        this.accountConsent = false;
        this.isAccountIsSend = false;
        this.isFormIsSend = false;
        this.dateConsentementForm = 0;
        this.dateConsentementGPS= 0;
        this.startValidity = 0;
        this.endValidity = 0;
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

    public void setPeriodValid(Date dateStart, Time timeStart, Date dateEnd, Time timeEnd) {
        setPeriodValid(FormModel.formatToTimestamp(dateStart, timeStart),
                FormModel.formatToTimestamp(dateEnd, timeEnd));
    }

    private void setPeriodValid(long dateStart, long dateEnd) {
        this.startValidity = dateStart;
        this.endValidity = dateEnd;
    }

    private String generateID(Context context) {
        String androidId = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
        return Long.toString(Math.abs(androidId.hashCode()));
    }


    public void setFormIsSend(boolean formIsSend) {
        isFormIsSend = formIsSend;
    }

    public void setAccountIsSend(boolean accountIsSend) {
        isAccountIsSend = accountIsSend;
    }

    public boolean isFormIsSend() {
        return isFormIsSend;
    }

    public boolean isAccountIsSend() {
        return isAccountIsSend;
    }

    public long getDateConsentementForm() {
        return dateConsentementForm;
    }

    public long getDateConsentementGPS() {
        return dateConsentementGPS;
    }

    public void setDateConsentementForm(long dateConsentementForm) {
        this.dateConsentementForm = dateConsentementForm;
    }

    public void setDateConsentementGPS(long dateConsentementGPS) {
        this.dateConsentementGPS = dateConsentementGPS;
    }

    public void store(Context context) {
        UserPreferences.storeInstance(context, this);
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

    public void setConsent() {
        this.consent = true;
    }

    public void setGpsConsent(boolean consent) {
        this.gpsConsent = consent;
    }

    public void setAccountConsent(boolean consent) {
        this.accountConsent = consent;
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
                ", startValidity=" + startValidity+
                ", endValidity=" + endValidity+
                ", dateConsentementGPS='" + dateConsentementGPS+ '\'' +
                ", dateConsentementForm='" + dateConsentementForm+ '\'' +
                ", language='" + language + '\'' +
                '}';
    }
}
