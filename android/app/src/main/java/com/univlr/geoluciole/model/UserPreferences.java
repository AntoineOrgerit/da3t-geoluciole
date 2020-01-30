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

package com.univlr.geoluciole.model;

import android.content.Context;
import android.provider.Settings;
import android.util.Log;

import com.univlr.geoluciole.model.form.FormModel;
import com.univlr.geoluciole.utils.Time;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import static com.univlr.geoluciole.utils.PreferencesManager.getSavedObjectFromPreference;
import static com.univlr.geoluciole.utils.PreferencesManager.saveObjectToSharedPreference;


public class UserPreferences {
    private static final String USER_PREFERENCE_KEY = "userPreferenceKey";
    private static final String USER_PREFERENCE_FILENAME = "UserPreference";
    private static final String TAG = UserPreferences.class.getSimpleName();

    private final String id;
    private boolean consent;
    private boolean gpsConsent;
    private long dateConsentementGPS;
    private long dateConsentementForm;
    private boolean accountConsent;
    private long startValidity;
    private long endValidity;
    private String language;
    private final List<String> listUnlockedBadges;
    private float distance;
    private boolean sendData;

    private boolean isGpsAutorize;

    private boolean isAccountIsSend;
    private boolean isFormIsSend;

    private boolean isManagerPermissionConstructorShow;
    private boolean isManagerPermissionBatteryShow;

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
        this.listUnlockedBadges = new ArrayList<>();
        this.distance = 0;
        this.isManagerPermissionBatteryShow = false;
        this.isManagerPermissionConstructorShow = false;
        this.isGpsAutorize = false;
    }

    public static UserPreferences getInstance(Context context) {
        UserPreferences userPreferences = getSavedObjectFromPreference(context, UserPreferences.USER_PREFERENCE_FILENAME, UserPreferences.USER_PREFERENCE_KEY, UserPreferences.class);
        if (userPreferences == null) {
            String lang = Locale.getDefault().getDisplayLanguage();
            userPreferences = new UserPreferences(lang, context);
        }
        return userPreferences;
    }

    /**
     * Méthode permettant d'enregistrer les préférences de l'utilisateur
     *
     * @param context Context
     * @param u       UserPréférences objet à sauvegarder
     */
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

    /**
     * Méthode permettant de générer un id unique correspondant à l'utilisateur
     * Se base sur le numéro du device
     *
     * @param context Context
     * @return String correspondant à l'id généré
     */
    private String generateID(Context context) {
        String androidId = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
        Log.i(TAG, "generateID, android ID " + androidId);
        return Long.toString(Math.abs(androidId.hashCode()));
    }

    public void setGpsAutorize(boolean gpsAutorize) {
        isGpsAutorize = gpsAutorize;
    }

    public boolean isGpsAutorize() {
        return isGpsAutorize;
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

    public void setManagerPermissionConstructorShow(boolean managerPermissionConstructorShow) {
        isManagerPermissionConstructorShow = managerPermissionConstructorShow;
    }

    public void setManagerPermissionBatteryShow(boolean managerPermissionBatteryShow) {
        isManagerPermissionBatteryShow = managerPermissionBatteryShow;
    }

    public boolean isManagerPermissionBatteryShow() {
        return isManagerPermissionBatteryShow;
    }

    public boolean isManagerPermissionConstructorShow() {
        return isManagerPermissionConstructorShow;
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

    public void setConsent(boolean consent) {
        this.consent = consent;
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

    public List<String> getListUnlockedBadges() {
        return listUnlockedBadges;
    }

    public long getStartValidity() {
        return startValidity;
    }

    public long getEndValidity() {
        return endValidity;
    }

    public float getDistance() {
        return distance;
    }

    public void setDistance(float distance) {
        this.distance = distance;
    }

    public boolean isSendData() {
        return sendData && isGpsConsent();
    }

    public void setSendData(boolean sendData) {
        this.sendData = sendData;
    }

    @Override
    public String toString() {
        return "UserPreferences{" +
                "id='" + id + '\'' +
                ", consent=" + consent +
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
