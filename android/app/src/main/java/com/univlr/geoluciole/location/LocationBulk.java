package com.univlr.geoluciole.location;

import android.location.Location;

import com.univlr.geoluciole.sender.BulkObject;

public class LocationBulk implements BulkObject {

    private Location location;

    public LocationBulk(Location location) {
        this.location = location;
    }

    @Override
    public String jsonFormat() {
        StringBuilder stringBuilder = new StringBuilder("{");
        stringBuilder.append("\"latitude\":").append(location.getLatitude()).append(",");
        stringBuilder.append("\"longitude\":").append(location.getLongitude()).append(",");
        stringBuilder.append("\"altitude\":").append(location.getAltitude()).append(",");
        stringBuilder.append("\"timestamp\":").append(location.getTime());
        stringBuilder.append("}");
        return stringBuilder.toString();
    }
}
