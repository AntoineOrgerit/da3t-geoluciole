package com.univlr.geoluciole.location;

import android.location.Location;

import com.univlr.geoluciole.sender.BulkObject;

import java.util.List;

public class LocationBulk implements BulkObject {

    private Location location;
    private String id;

    public LocationBulk(Location location, String id) {
        this.location = location;
        this.id = id;
    }

    @Override
    public List<String> jsonFormatObject() {
        return null;
    }

    @Override
    public boolean hasMultipleObject() {
        return false;
    }

    @Override
    public String jsonFormat() {
        StringBuilder stringBuilder = new StringBuilder("{");
        stringBuilder.append("\"id\":").append(id).append(",");
        stringBuilder.append("\"latitude\":").append(location.getLatitude()).append(",");
        stringBuilder.append("\"longitude\":").append(location.getLongitude()).append(",");
        stringBuilder.append("\"altitude\":").append(location.getAltitude()).append(",");
        stringBuilder.append("\"timestamp\":").append(location.getTime());
        stringBuilder.append("}");
        return stringBuilder.toString();
    }
}
