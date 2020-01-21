package com.univlr.geoluciole.model.badge;

import android.location.Location;

public class BadgePlace extends Badge {
    private Location location;
    private Double proximity;


    public BadgePlace() {
        this.location = new Location("");
    }

    public Location getLocation() {
        return location;
    }

    public void setLocation(Location location) {
        this.location = location;
    }

    public Double getProximity() {
        return proximity;
    }

    public void setProximity(Double proximity) {
        this.proximity = proximity;
    }


    @Override
    public String toString() {
        return super.toString() +
                "location=" + location +
                ", proximity=" + proximity +
                '}';
    }
}
