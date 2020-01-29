/*
 * Copyright (c) 2020, La Rochelle Université
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *  Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *  Neither the name of the University of California, Berkeley nor the
 *   names of its contributors may be used to endorse or promote products
 *   derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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
