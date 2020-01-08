package com.univlr.geoluciole.permissions;

import android.Manifest;

public enum Permission {

    INTERNET_PERMISSION(Manifest.permission.INTERNET, 1),
    FINE_LOCATION_PERMISSION(Manifest.permission.ACCESS_FINE_LOCATION, 2);

    private String manifestValue;
    private int uniqueID;

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
