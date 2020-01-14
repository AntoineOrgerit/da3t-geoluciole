package com.univlr.geoluciole.model;

import java.io.Serializable;

public class FormModel implements Serializable {
    private String dateIn;
    private String timeIn;
    private String dateOut;
    private String timeOut;

    private String withWhom;
    private boolean firstTime;
    private boolean knowCity;
    private boolean fiveTimes;
    private boolean twoMonths;
    private String transport;

    public FormModel() {

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

    public void setDateIn(String dateIn) {
        this.dateIn = dateIn;
    }

    public String getTimeIn() {
        return timeIn;
    }

    public void setTimeIn(String timeIn) {
        this.timeIn = timeIn;
    }

    public String getDateOut() {
        return dateOut;
    }

    public void setDateOut(String dateOut) {
        this.dateOut = dateOut;
    }

    public String getTimeOut() {
        return timeOut;
    }

    public void setTimeOut(String timeOut) {
        this.timeOut = timeOut;
    }
}
