package com.univlr.geoluciole.model.badge;

/**
 * classe Badge
 */
public class Badge {
    private String id;
    private String name;
    private String description;

    /**
     * Constructeur de la classe
     */
    public Badge() {
        // on set les attributs avec les setter dans BadgeManager lors de l'instanciation
    }

    /**
     * Getter id
     *
     * @return String
     */
    public String getId() {
        return id;
    }

    /**
     * Setter id
     *
     * @param id String
     */
    public void setId(String id) {
        this.id = id;
    }

    /**
     * Getter name
     *
     * @return String
     */
    public String getName() {
        return name;
    }

    /**
     * Setter name
     *
     * @param name String
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Getter description
     *
     * @return String
     */
    public String getDescription() {
        return description;
    }

    /**
     * Setter description
     *
     * @param description String
     */
    public void setDescription(String description) {
        this.description = description;
    }


    /**
     * Redéfinition de la méthode toString
     *
     * @return String représentant l'objet sous forme de chaine de caractères
     */
    @Override
    public String toString() {
        return "Badge{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", ";
    }
}
