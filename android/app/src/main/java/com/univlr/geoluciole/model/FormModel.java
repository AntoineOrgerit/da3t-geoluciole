package com.univlr.geoluciole.model;

import com.univlr.geoluciole.sender.BulkObject;

import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class FormModel implements Serializable, BulkObject {

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

    private Calendar datetimeStart;
    private Calendar datetimeEnd;
    private String id_user;
    private String dateIn;
    private String timeIn;
    private String dateOut;
    private String timeOut;

    private String withWhom;
    private boolean presenceChildren;
    private boolean presenceTeens;
    private boolean firstTime;
    private boolean knowCity;
    private boolean fiveTimes;
    private boolean twoMonths;
    private String transport;

    public FormModel(String id_user) {
        this.id_user = id_user;
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

    public String getDateIn() {
        return dateIn;
    }


    public Calendar getDatetimeEnd() {
        return datetimeEnd;
    }

    public Calendar getDatetimeStart() {
        return datetimeStart;
    }

    public void setDatetimeEnd(Calendar datetimeEnd) {
        this.datetimeEnd = datetimeEnd;
        this.dateOut = this.datetimeEnd.get(Calendar.DAY_OF_MONTH) + "-" + this.datetimeEnd.get(Calendar.MONTH)
                + "-" + this.datetimeEnd.get(Calendar.YEAR);
        this.timeOut = this.datetimeEnd.get(Calendar.HOUR_OF_DAY) + ":" + this.datetimeEnd.get(Calendar.MINUTE);
    }

    public void setDatetimeStart(Calendar datetimeStart) {
        this.datetimeStart = datetimeStart;
        this.dateIn = this.datetimeStart.get(Calendar.DAY_OF_MONTH) + "-" + this.datetimeStart.get(Calendar.MONTH)
                + "-" + this.datetimeStart.get(Calendar.YEAR);
        this.timeIn = this.datetimeStart.get(Calendar.HOUR_OF_DAY) + ":" + this.datetimeStart.get(Calendar.MINUTE);
    }

    public String getTimeIn() {
        return timeIn;
    }


    public String getDateOut() {
        return dateOut;
    }


    public String getTimeOut() {
        return timeOut;
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

    @Override
    public String toString() {
        String res = "FormModel{" +
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
                ", transport='" + transport + '\'';
        if (datetimeStart != null) {
            res += ", datetimeStart='" + datetimeStart.getTime().getTime()+"'";
        }
        if (datetimeEnd != null) {
            res += ", datetimeEnd='" + datetimeEnd.getTime().getTime()+"'";
        }

        return res + '}';
    }

    private Date convertToDate(String sdt, String stime) {
        sdt += " "+stime;
        SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        Date date;
        try {
            date = format.parse(sdt);
        } catch (ParseException e) {
            date = new Date();
            e.printStackTrace();
        }
        return date;
    }

    private String convertToTimestamp(String sdt, String stime) {
        return "" + convertToDate(sdt, stime).getTime();
    }

    private String InJson(String value, int id_question) {
        return "{\"id_user\":"+id_user+",\"id_question\":"+id_question+",\"reponse\":\""+value+"\"}";
    }

    private String booleanToString(boolean bool) {
        return bool ? "true" : "false";
    }

    @Override
    public List<String> jsonFormatObject() {
        List<String> result = new ArrayList<>();
        result.add(InJson(""+datetimeStart.getTime().getTime(), ID_QUESTION_DATE_IN));
        result.add(InJson(""+datetimeEnd.getTime().getTime(), ID_QUESTION_DATE_OUT));
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

    @Override
    public boolean hasMultipleObject() {
        return true;
    }

    @Override
    public String jsonFormat() {
        return null;
    }
}
