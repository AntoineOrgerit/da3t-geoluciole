package com.univlr.geoluciole.model;

import androidx.annotation.NonNull;

import org.json.JSONException;
import org.json.JSONObject;

public class Location {
    private double latitude;
    private double longitude;
    private long timestamp;
    private double altitude;
    private int isSync; // 1 pour envoi ack serveur sinon 0

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
     * @param isSync
     */
    public Location(double latitude, double longitude, long timestamp, double altitude, int isSync) {
        super();
        this.longitude = longitude;
        this.latitude = latitude;
        this.timestamp = timestamp;
        this.altitude = altitude;
        this.isSync = isSync;
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

    /**
     * Getter pour l ack serveur
     *
     * @return int
     */
    public int getIsSync() {
        return isSync;
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
     * Setter de l ack serveur
     *
     * @param isSync int 1 si le serveur a recu la trace sinon 0
     */
    public void setIsSync(int isSync) {
        this.isSync = isSync;
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
                ", isSync=" + isSync +
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
            jo.put("isSync", getIsSync());
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jo;
    }
}
