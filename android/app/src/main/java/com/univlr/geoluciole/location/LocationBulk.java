/*
 * Copyright (c) 2020, Martin Allusse and Alexandre Baret and Jessy Barritault and Florian
 * Bertonnier and Lisa Fougeron and François Gréau and Thibaud Lambert and Antoine
 * Orgerit and Laurent Rayez
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
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
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

package com.univlr.geoluciole.location;

import android.location.Location;

import com.univlr.geoluciole.model.form.FormModel;
import com.univlr.geoluciole.sender.BulkObject;

import java.util.List;

/**
 * Objet utilisée pour parser les données location et les envoyer au server sous un format bulk ** voir class BulkObject
 */
public class LocationBulk implements BulkObject {

    private final Location location;
    private final String id;

    /**
     * Création d'un location bulk
     *
     * @param location location a parse
     * @param id identifiant utilisateur (unique ID du UserPreference)
     */
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
        /**
         * Attention à bien penser à mettre les chaine de caractère entre quote.
         */
        StringBuilder stringBuilder = new StringBuilder("{");
        stringBuilder.append("\"id_user\":").append(id).append(",");
        stringBuilder.append("\"latitude\":").append(location.getLatitude()).append(",");
        stringBuilder.append("\"longitude\":").append(location.getLongitude()).append(",");
        stringBuilder.append("\"altitude\":").append(location.getAltitude()).append(",");
        stringBuilder.append("\"timestamp\":").append(location.getTime()).append(",");
        stringBuilder.append("\"vitesse\":").append(location.getSpeed()).append(",");
        stringBuilder.append("\"date_str\":").append("\""+FormModel.dateFormatStr(location.getTime())+"\"").append(",");
        stringBuilder.append("\"precision\":").append(location.getAccuracy());
        stringBuilder.append("}");
        return stringBuilder.toString();
    }
}
