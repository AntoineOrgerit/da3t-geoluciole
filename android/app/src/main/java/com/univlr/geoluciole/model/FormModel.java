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

package com.univlr.geoluciole.model;

import android.content.Context;

import com.univlr.geoluciole.R;
import com.univlr.geoluciole.sender.BulkObject;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import static com.univlr.geoluciole.model.PreferencesManager.getSavedObjectFromPreference;
import static com.univlr.geoluciole.model.PreferencesManager.saveObjectToSharedPreference;

public class FormModel implements Serializable, BulkObject {
    public static final String FORM_KEY = "formModelPreference";
    public static final String FORM_FILENAME = "formModelFilePreference";

    private static final int ID_QUESTION_DATE_IN = 1;
    private static final int ID_QUESTION_DATE_OUT = 2;
    private static final int ID_QUESTION_WITH_WHOM = 3;
    private static final int ID_QUESTION_PRESENCE_CHILDREN = 4;
    private static final int ID_QUESTION_PRESENCE_TEEN = 5;
    private static final int ID_QUESTION_FIRST_TIME = 6;
    private static final int ID_QUESTION_KNOW_CITY = 7;
    private static final int ID_QUESTION_FIVE_TIMES = 8;
    private static final int ID_QUESTION_TWO_MONTH = 9;
    private static final int ID_QUESTION_TRANSPORT = 10;

    private String idUser;
    private Date dateIn;
    private Time timeIn;
    private Date dateOut;
    private Time timeOut;

    private String withWhom;
    private boolean presenceChildren;
    private boolean presenceTeens;
    private boolean firstTime;
    private boolean knowCity;
    private boolean fiveTimes;
    private boolean twoMonths;
    private String transport;

    private String device;
    private String version;

    public FormModel(String idUser) {
        this.idUser = idUser;
        this.device = "Inconnu";
        this.version = "";
    }

    public String getWithWhom() {
        return withWhom;
    }

    public void setWithWhom(String withWhom) {
        this.withWhom = withWhom;
    }

    public boolean isFirstTime() {
        return firstTime;
    }

    public void setFirstTime(boolean firstTime) {
        this.firstTime = firstTime;
    }

    public boolean isKnowCity() {
        return knowCity;
    }

    public void setKnowCity(boolean knowCity) {
        this.knowCity = knowCity;
    }

    public boolean isFiveTimes() {
        return fiveTimes;
    }

    public void setFiveTimes(boolean fiveTimes) {
        this.fiveTimes = fiveTimes;
    }

    public boolean isTwoMonths() {
        return twoMonths;
    }

    public void setTwoMonths(boolean twoMonths) {
        this.twoMonths = twoMonths;
    }

    public String getTransport() {
        return transport;
    }

    public void setTransport(String transport) {
        this.transport = transport;
    }

    public Date getDateIn() {
        return dateIn;
    }

    public Time getTimeIn() {
        return timeIn;
    }


    public Date getDateOut() {
        return dateOut;
    }

    public Time getTimeOut() {
        return timeOut;
    }

    public void setDateIn(Date dateIn) {
        this.dateIn = dateIn;
    }

    public void setDateOut(Date dateOut) {
        this.dateOut = dateOut;
    }

    public void setTimeIn(Time timeIn) {
        this.timeIn = timeIn;
    }

    public void setTimeOut(Time timeOut) {
        this.timeOut = timeOut;
    }

    public long getTimestampStart() {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(dateIn);
        calendar.set(Calendar.HOUR_OF_DAY, timeIn.getHours());
        calendar.set(Calendar.MINUTE, timeIn.getMinutes());
        return calendar.getTime().getTime();
    }

    public long getTimestampEnd() {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(dateOut);
        calendar.set(Calendar.HOUR_OF_DAY, timeOut.getHours());
        calendar.set(Calendar.MINUTE, timeOut.getMinutes());
        return calendar.getTime().getTime();
    }

    public boolean isPresenceChildren() {
        return presenceChildren;
    }

    public void setPresenceChildren(boolean presenceChildren) {
        this.presenceChildren = presenceChildren;
    }

    public boolean isPresenceTeens() {
        return presenceTeens;
    }

    public void setPresenceTeens(boolean presenceTeens) {
        this.presenceTeens = presenceTeens;
    }

    public String getDevice() {
        return device;
    }

    public void setDevice(String device) {
        this.device = device;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public static String datetimeToString(Date date, Time time) {
        return dateToString(date) + " " + timeToString(time);
    }

    public static long formatToTimestamp(Date date, Time time) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.MINUTE, time.getMinutes());
        calendar.set(Calendar.HOUR_OF_DAY, time.getHours());
        return calendar.getTimeInMillis();
    }


    public static String datetimeToString(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return datetimeToString(calendar);
    }

    public static String datetimeToString(Calendar c) {
        return FormModel.dateToString(c) + " " + FormModel.timeToString(c);
    }

    public static String timeToString(Calendar calendar) {
        return timeToString(new Time(calendar.get(Calendar.HOUR_OF_DAY), calendar.get(Calendar.MINUTE)));
    }

    public static String timeToString(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return timeToString(calendar);
    }

    public static String timeToString(Time time) {
        return time.toString();
    }

    public static String dateToString(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return dateToString(calendar);
    }

    public static String dateToString(Calendar c) {
        int day = c.get(Calendar.DAY_OF_MONTH);
        String sday = day < 10 ? "0" + day : "" + day;
        int month = c.get(Calendar.MONTH);
        String smonth = month < 10 ? "0" + (month + 1) : "" + (month + 1);
        return sday + "-" + smonth + "-" + c.get(Calendar.YEAR);
    }

    @Override
    public String toString() {
        return "FormModel{" +
                "dateIn='" + dateIn + '\'' +
                ", timeIn='" + timeIn + '\'' +
                ", dateOut='" + dateOut + '\'' +
                ", timeOut='" + timeOut + '\'' +
                ", withWhom='" + withWhom + '\'' +
                ", presenceChildren=" + presenceChildren +
                ", presenceTeens=" + presenceTeens +
                ", firstTime=" + firstTime +
                ", knowCity=" + knowCity +
                ", fiveTimes=" + fiveTimes +
                ", twoMonths=" + twoMonths +
                ", transport='" + transport + '\''
                + '}';
    }

    private String InJson(String value, int idQuestion) {
        return "{\"id_user\":" + idUser + ",\"id_question\":" + idQuestion + ",\"reponse\":\"" + value + "\"}";
    }

    private String booleanToString(boolean bool) {
        return bool ? "true" : "false";
    }

    @Override
    public List<String> jsonFormatObject() {
        List<String> result = new ArrayList<>();
        result.add(InJson("" + getTimestampStart(), ID_QUESTION_DATE_IN));
        result.add(InJson("" + getTimestampEnd(), ID_QUESTION_DATE_OUT));
        result.add(InJson(withWhom, ID_QUESTION_WITH_WHOM));
        result.add(InJson(booleanToString(presenceChildren), ID_QUESTION_PRESENCE_CHILDREN));
        result.add(InJson(booleanToString(presenceTeens), ID_QUESTION_PRESENCE_TEEN));
        result.add(InJson(booleanToString(firstTime), ID_QUESTION_FIRST_TIME));
        result.add(InJson(booleanToString(knowCity), ID_QUESTION_KNOW_CITY));
        result.add(InJson(booleanToString(fiveTimes), ID_QUESTION_FIVE_TIMES));
        result.add(InJson(booleanToString(twoMonths), ID_QUESTION_TWO_MONTH));
        result.add(InJson(transport, ID_QUESTION_TRANSPORT));
        return result;
    }

    public static String dateFormatStr(long timestamp) {
        Calendar c = Calendar.getInstance();
        c.setTimeInMillis(timestamp);
        int day = c.get(Calendar.DAY_OF_MONTH);
        String sday = day < 10 ? "0" + day : "" + day;
        int month = c.get(Calendar.MONTH);
        String smonth = month < 10 ? "0" + (month + 1) : "" + (month + 1);
        int second = c.get(Calendar.SECOND);
        String sSecond = second < 10 ? "0" + second : "" + second;
        //yyyy/MM/dd HH:mm:ss
        return c.get(Calendar.YEAR) + "/" + smonth + "/" + sday + " " + FormModel.timeToString(c) + ":" + second;
    }

    @Override
    public boolean hasMultipleObject() {
        return true;
    }

    @Override
    public String jsonFormat() {
        return null;
    }

    public static FormModel getInstance(Context context) {
        return getSavedObjectFromPreference(context, FormModel.FORM_FILENAME, FormModel.FORM_KEY, FormModel.class);
    }

    public static void storeInstance(Context context, FormModel form) {
        saveObjectToSharedPreference(context, FormModel.FORM_FILENAME, FormModel.FORM_KEY, form);
    }

    public void storeInstance(Context context) {
        FormModel.storeInstance(context, this);
    }

    protected String formatAccount(Context context, UserPreferences userPreferences) {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append("\"id_user\":").append(userPreferences.getId()).append(",");
        stringBuilder.append("\"date_gps\":").append(userPreferences.getDateConsentementGPS()).append(",");
        stringBuilder.append("\"date_gps_str\":").append("\""+FormModel.dateFormatStr(userPreferences.getDateConsentementGPS())+"\"").append(",");
        stringBuilder.append("\"type\":").append("\"android\"").append(",");
        stringBuilder.append("\"model\":").append("\"" + this.device + "\"").append(",");
        stringBuilder.append("\"version\":").append("\"" + this.version + "\"").append(",");
        stringBuilder.append("\"consentement_gps\":").append("\"" + context.getResources().getString(R.string.rgpd_first_content_consentement) + "\"");
        return stringBuilder.toString();
    }

    public String getStringAccount(Context context, UserPreferences userPreferences) {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append("{");
        stringBuilder.append(this.formatAccount(context, userPreferences));
        stringBuilder.append("}");
        return stringBuilder.toString();
    }
}
