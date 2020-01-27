package com.univlr.geoluciole.model.badge;

/**
 * classe BadgeDistance hérite de Badge
 * Concerne les badges de type "distance"
 */
public class BadgeDistance extends Badge {
    private double distance;

    /**
     * Constructeur de la classe
     */
    public BadgeDistance() {
        // on set les attributs avec les setter dans BadgeManager lors de l'instanciation
    }

    /**
     * Getter distance
     *
     * @return double
     */
    public double getDistance() {
        return distance;
    }

    /**
     * Setter distance
     *
     * @param distance double
     */
    public void setDistance(double distance) {
        this.distance = distance;
    }

    /**
     * Redéfinition de la méthode toString
     *
     * @return String représentant l'objet sous forme de chaine de caractères
     */
    @Override
    public String toString() {
        return super.toString() +
                "distance=" + distance +
                '}';
    }
}
