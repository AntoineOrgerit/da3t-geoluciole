package com.univlr.geoluciole.permissions;

import android.Manifest;

public enum Permission {

    IGNORE_BATTERY_OPTIMIZATIONS_PERMISSION(Manifest.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS, 1),
    INTERNET_PERMISSION(Manifest.permission.INTERNET, 2),
    FINE_LOCATION_PERMISSION(Manifest.permission.ACCESS_FINE_LOCATION, 3);

    private String manifestValue;
    private int uniqueID;

    @SuppressWarnings("unused")
    Permission(String manifestValue, int uniqueID) {
        this.manifestValue = manifestValue;
        this.uniqueID = uniqueID;
    }

    public String getManifestValue() {
        return manifestValue;
    }

    public int getUniqueID() {
        return uniqueID;
    }
}
