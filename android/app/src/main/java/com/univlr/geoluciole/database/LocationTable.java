package com.univlr.geoluciole.database;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.util.Log;

import com.univlr.geoluciole.model.Location;

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

    /**
     * Constructeur de la classe
     */
    public LocationTable() {
        super();
        this.tableName = LOCATION_TABLE_NAME;
        this.columns = new TableColumn[]{
                new TableColumn(LATITUDE, "DOUBLE", false),
                new TableColumn(LONGITUDE, "DOUBLE", false),
                new TableColumn(TIMESTAMP, "TIMESTAMP", false),
                new TableColumn(ALTITUDE, "DOUBLE", false),
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
    public void insertObject(Object o) {
        Location l = (Location) o;
        ContentValues values = new ContentValues();
        values.put(LocationTable.LATITUDE, l.getLatitude());
        values.put(LocationTable.LONGITUDE, l.getLongitude());
        values.put(LocationTable.TIMESTAMP, l.getTimestamp());
        values.put(LocationTable.ALTITUDE, l.getAltitude());
        Log.i("DATABASE", "addLocation - Ajout d une location dans la base de donnee");
        System.out.println(values);
        this.dbSQLite.getDb().insert(LocationTable.LOCATION_TABLE_NAME, null, values);
    }


    /**
     * Permet de supprimer tous les objets de la table
     */
    @Override
    public void removeAllObject() {
        this.dbSQLite.getDb().delete(LocationTable.LOCATION_TABLE_NAME, null, null);
    }

    /**
     * Get toutes les locations de la BDD
     *
     * @return List de tous les objets Locations
     */
    @Override
    public List getAllObject() {
        List<Location> locationList = new ArrayList();
        String[] columnArray = {
                LocationTable.LATITUDE + "," + LocationTable.LONGITUDE + "," +
                        LocationTable.TIMESTAMP + "," + LocationTable.ALTITUDE};
        Cursor cursor = this.dbSQLite.getDb().query(LocationTable.LOCATION_TABLE_NAME,
                columnArray, null, null, null, null, null, null);

        if (cursor.getCount() > 0) {
            cursor.moveToFirst();
            do {
                Location location = new Location();
                location.setLatitude(cursor.getDouble(cursor.getColumnIndex(LocationTable.LATITUDE)));
                location.setLongitude(cursor.getDouble(cursor.getColumnIndex(LocationTable.LONGITUDE)));
                location.setTimestamp(cursor.getInt(cursor.getColumnIndex(LocationTable.TIMESTAMP)));
                location.setAltitude(cursor.getDouble(cursor.getColumnIndex(LocationTable.ALTITUDE)));
                locationList.add(location);
            } while (cursor.moveToNext());
            cursor.close();
        } else {
            Log.i("DATABASE", "getAll - Pas de valeurs trouvees");
        }
        Log.i("DATABASE", "getAll - valeurs recuperees");
        return locationList;
    }


}