package com.univlr.geoluciole.model;

import java.io.Serializable;

public class Time implements Serializable {
    private int hours;
    private int minutes;

    public Time() {
        hours = 0;
        minutes = 0;
    }

    public Time(int hours, int minutes) {
        this.minutes = minutes;
        this.hours = hours;
    }

    public void setHours(int hours) {
        this.hours = hours;
    }

    public void setMinutes(int minutes) {
        this.minutes = minutes;
    }

    public int getHours() {
        return hours;
    }

    public int getMinutes() {
        return minutes;
    }

    @Override
    public String toString() {
        String minutes = this.minutes < 10 ? "0" + (this.minutes) : this.minutes + "";
        String hours = this.hours < 10 ? "0" + (this.hours) : this.hours + "";
        return hours+":"+minutes;
    }
}