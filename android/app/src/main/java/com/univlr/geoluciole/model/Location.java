package com.univlr.geoluciole.model;

import androidx.annotation.NonNull;

import org.json.JSONException;
import org.json.JSONObject;

public class Location {
    private double latitude;
    private double longitude;
    private long timestamp;
    private double altitude;


    /**
     * Constructeur par defaut
     */
    public Location() {
        super();
    }

    /**
     * Constructeur de la classe
     *
     * @param latitude
     * @param longitude
     * @param timestamp
     * @param altitude
     */
    public Location(double latitude, double longitude, long timestamp, double altitude) {
        super();
        this.longitude = longitude;
        this.latitude = latitude;
        this.timestamp = timestamp;
        this.altitude = altitude;

    }

    /**
     * Getter pour la latitude
     *
     * @return double
     */
    public double getLatitude() {
        return latitude;
    }

    /**
     * Getter pour la longitude
     *
     * @return double
     */
    public double getLongitude() {
        return longitude;
    }

    /**
     * Getter pour le timestamp
     *
     * @return long
     */
    public long getTimestamp() {
        return timestamp;
    }

    /**
     * Getter pour l altitude
     *
     * @return double
     */
    public double getAltitude() {
        return altitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public void setAltitude(double altitude) {
        this.altitude = altitude;
    }

    /**
     * Redefinition de la methode toString
     *
     * @return String representant la Location
     */
    @NonNull
    @Override
    public String toString() {
        return "Location{" +
                "longitude=" + longitude +
                ", latitude=" + latitude +
                ", timestamp=" + timestamp +
                ", altitude=" + altitude +
                '}';
    }

    /**
     * Methode permettant de parser la Location en JSON
     *
     * @return JSONObject
     */
    public JSONObject parseToJson() {
        JSONObject jo = new JSONObject();
        try {
            jo.put("latitude", getLatitude());
            jo.put("longitude", getLongitude());
            jo.put("timestamp", getTimestamp());
            jo.put("altitude", getAltitude());
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jo;
    }
}
