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

    private String id_user;
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

    public static String datetimeToString(Date date, Time time) {
        return dateToString(date) + " " + timeToString(time);
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
        String sday = day  < 10 ? "0"+day : ""+day;
        int month = c.get(Calendar.MONTH);
        String smonth = month < 10 ? "0"+(month+1) : ""+(month+1);
        return  sday + "-" + smonth + "-" + c.get(Calendar.YEAR);
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
        result.add(InJson(""+getTimestampStart(), ID_QUESTION_DATE_IN));
        result.add(InJson(""+getTimestampEnd(), ID_QUESTION_DATE_OUT));
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
