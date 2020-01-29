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

package com.univlr.geoluciole.database;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.DatabaseUtils;
import android.location.Location;
import android.util.Log;

import com.univlr.geoluciole.location.LocationBulk;
import com.univlr.geoluciole.model.UserPreferences;

import java.util.ArrayList;
import java.util.List;

/**
 * Classe LocationTable - herite de la classe Table
 */
public class LocationTable extends Table {
    public static final String LOCATION_TABLE_NAME = "locations";
    public static final String LATITUDE = "latitude";
    public static final String LONGITUDE = "longitude";
    public static final String TIMESTAMP = "time_stamp";
    public static final String ALTITUDE = "altitude";
    public static final String ACCURACY = "precision";
    public static final String SPEED = "vitesse";

    /**
     * Constructeur de la classe
     */
    public LocationTable() {
        super();
        this.tableName = LOCATION_TABLE_NAME;
        this.columns = new TableColumn[]{
                new TableColumn(LATITUDE, "DOUBLE", true),
                new TableColumn(LONGITUDE, "DOUBLE", true),
                new TableColumn(TIMESTAMP, "TIMESTAMP", false),
                new TableColumn(ALTITUDE, "DOUBLE", true),
                new TableColumn(ACCURACY, "DOUBLE", true),
                new TableColumn(SPEED, "DOUBLE", true),
        };
    }

    /**
     * Constructeur recuperant l instance de la base
     *
     * @param context
     */
    public LocationTable(Context context) {
        super(context);
    }

    /**
     * Ajouter une localisation dans la table de la BDD
     *
     * @param o Object a inserer dans la table
     */
    @Override
    protected void insertObject(Object o) {
        Location l = (Location) o;
        ContentValues values = new ContentValues();
        values.put(LocationTable.LATITUDE, l.getLatitude());
        values.put(LocationTable.LONGITUDE, l.getLongitude());
        values.put(LocationTable.TIMESTAMP, l.getTime());
        values.put(LocationTable.ALTITUDE, l.getAltitude());
        values.put(LocationTable.SPEED, l.getSpeed());
        values.put(LocationTable.ACCURACY, l.getAccuracy());
        Log.i("DATABASE", "addLocation - Ajout d une location dans la base de donnee");
        this.dbSQLite.getDb().insert(LocationTable.LOCATION_TABLE_NAME, null, values);
    }


    /**
     * Permet de supprimer tous les objets de la table
     */
    @Override
    protected void removeAllObject() {
        this.dbSQLite.getDb().delete(LocationTable.LOCATION_TABLE_NAME, null, null);
    }

    /**
     * Get toutes les locations de la BDD
     *
     * @return List de tous les objets Locations
     */
    @Override
    protected List getAllObject() {
        List<LocationBulk> locationList = new ArrayList();
        String[] columnArray = {
                LocationTable.LATITUDE + "," + LocationTable.LONGITUDE + "," +
                        LocationTable.TIMESTAMP + "," + LocationTable.ALTITUDE + "," +LocationTable.SPEED + ","+ LocationTable.ACCURACY};
        Cursor cursor = this.dbSQLite.getDb().query(LocationTable.LOCATION_TABLE_NAME,
                columnArray, null, null, null, null, null, null);

        UserPreferences userPref = UserPreferences.getInstance(this.context);

        if (cursor.getCount() > 0) {
            cursor.moveToFirst();
            do {
                Location location = new Location("");
                location.setLatitude(cursor.getDouble(cursor.getColumnIndex(LocationTable.LATITUDE)));
                location.setLongitude(cursor.getDouble(cursor.getColumnIndex(LocationTable.LONGITUDE)));
                location.setTime(cursor.getLong(cursor.getColumnIndex(LocationTable.TIMESTAMP)));
                location.setAltitude(cursor.getDouble(cursor.getColumnIndex(LocationTable.ALTITUDE)));
                location.setSpeed(cursor.getFloat(cursor.getColumnIndex(LocationTable.SPEED)));
                location.setAccuracy(cursor.getFloat(cursor.getColumnIndex(LocationTable.ACCURACY)));
                locationList.add(new LocationBulk(location, userPref.getId()));
            } while (cursor.moveToNext());
            cursor.close();
        } else {
            Log.i("DATABASE", "getAll - Pas de valeurs trouvees");
        }
        Log.i("DATABASE", "getAll - valeurs recuperees");
        return locationList;
    }


    public Location getLastLocation(){
        this.dbSQLite.open();
        String[] columnArray = {
                LocationTable.LATITUDE + "," + LocationTable.LONGITUDE + ", (SELECT max(time_stamp) from locations) AS time_stamp" + "," + LocationTable.ALTITUDE + "," +LocationTable.SPEED + ","+ LocationTable.ACCURACY};
        Cursor cursor = this.dbSQLite.getDb().query(LocationTable.LOCATION_TABLE_NAME,
                columnArray, null, null, null, null, null, null);


        Location location = new Location("");
        if (cursor.getCount() > 0) {
            cursor.moveToFirst();
            do {

                location.setLatitude(cursor.getDouble(cursor.getColumnIndex(LocationTable.LATITUDE)));
                location.setLongitude(cursor.getDouble(cursor.getColumnIndex(LocationTable.LONGITUDE)));
                location.setTime(cursor.getLong(cursor.getColumnIndex(LocationTable.TIMESTAMP)));
                location.setAltitude(cursor.getDouble(cursor.getColumnIndex(LocationTable.ALTITUDE)));
                location.setSpeed(cursor.getFloat(cursor.getColumnIndex(LocationTable.SPEED)));
                location.setAccuracy(cursor.getFloat(cursor.getColumnIndex(LocationTable.ACCURACY)));
            } while (cursor.moveToNext());
            cursor.close();
        } else {
            Log.i("DATABASE", "getLast - Pas de valeurs trouvees");
        }
        Log.i("DATABASE", "getLast - valeurs recuperees");
        this.dbSQLite.close();
        return location;
    }

    public long countAll() {
        this.dbSQLite.open();
        long count = DatabaseUtils.queryNumEntries(this.dbSQLite.getDb(), LOCATION_TABLE_NAME);
        this.dbSQLite.close();
        return count;
    }
}
