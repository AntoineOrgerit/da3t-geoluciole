package com.univlr.geoluciole.model.badge;

import android.location.Location;

/**
 * classe BadgePlace hérite de Badge
 * Concerne les badges de type "place"
 */
public class BadgePlace extends Badge {
    private Location location;
    private double proximity;

    /**
     * Constructeur de la classe, initialisation d'une location
     */
    public BadgePlace() {
        this.location = new Location("");
    }

    /**
     * Getter Location
     *
     * @return Location
     */
    public Location getLocation() {
        return location;
    }

    /**
     * Setter Location
     *
     * @param location Location
     */
    public void setLocation(Location location) {
        this.location = location;
    }

    /**
     * Getter proximity
     *
     * @return Double
     */
    public double getProximity() {
        return proximity;
    }

    /**
     * Setter proximity
     *
     * @param proximity double
     */
    public void setProximity(double proximity) {
        this.proximity = proximity;
    }

    /**
     * Redéfinition de la méthode toString
     *
     * @return String représentant l'objet sous forme de chaine de caractères
     */
    @Override
    public String toString() {
        return super.toString() +
                "location=" + location +
                ", proximity=" + proximity +
                '}';
    }
}
