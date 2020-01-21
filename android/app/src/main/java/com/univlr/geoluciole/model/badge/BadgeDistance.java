package com.univlr.geoluciole.model.badge;

public class BadgeDistance extends Badge {
    private double distance;

    public BadgeDistance() {
    }

    public BadgeDistance(String name, String description, String picture, double distance) {
        super(name, description, picture);
        this.distance = distance;
    }

    public double getDistance() {
        return distance;
    }

    public void setDistance(double distance) {
        this.distance = distance;
    }



    @Override
    public String toString() {
        return super.toString() +
                "distance=" + distance +
                '}';
    }
}
