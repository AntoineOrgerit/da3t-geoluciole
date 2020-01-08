package com.univlr.geoluciole.db.dao;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

import com.univlr.geoluciole.db.DatabaseManager;
import com.univlr.geoluciole.db.DatabaseStaticVariables;
import com.univlr.geoluciole.model.Location;

import java.util.ArrayList;
import java.util.List;

public class LocationDAO {
    private SQLiteDatabase db;
    private DatabaseManager dbSQLite;

    /**
     * Creation de la base de donnees
     *
     * @param context
     */
    public LocationDAO(Context context) {
        dbSQLite = DatabaseManager.getInstance(context);
    }

    /**
     * Ouverture de la BDD en ecriture
     */
    public void open() {
        db = dbSQLite.getWritableDatabase();
        Log.i("DATABASE", "Ouverture de la base de donnees en ecriture");
    }

    /**
     * Fermeture de la BDD
     */
    public void close() {
        db.close();
        Log.i("DATABASE", "Fermeture de la base de donnees en ecriture");
    }

    /**
     * Getter
     *
     * @return SQLiteDatabase
     */
    public SQLiteDatabase getDb() {
        return this.db;
    }

    /**
     * Ajouter une localisation dans la BDD
     *
     * @param l
     * @return long indiquant si l operation s est bien deroulee
     */
    public long addLocation(Location l) {
        ContentValues values = new ContentValues();
        values.put(DatabaseStaticVariables.LOCATION_LATITUDE, l.getLatitude());
        values.put(DatabaseStaticVariables.LOCATION_LONGITUDE, l.getLongitude());
        values.put(DatabaseStaticVariables.LOCATION_TIMESTAMP, l.getTimestamp());
        values.put(DatabaseStaticVariables.LOCATION_ALTITUDE, l.getAltitude());
        values.put(DatabaseStaticVariables.LOCATION_IS_SYNC, l.getIsSync());
        Log.i("DATABASE", "addLocation - Ajout d une location dans la base de donnee");
        return db.insert(DatabaseStaticVariables.LOCATION_TABLE_NAME, null, values);
    }

    /** todo voir si on delete les row qui ont ete envoyees au serveur, se baser sur isSync a 1
     * Vider la base de donnees locale
     *
     * @return
     */
    public long removeAll() {
        return db.delete(DatabaseStaticVariables.LOCATION_TABLE_NAME, null, null);
    }

    /**
     * Get toutes les locations de la BDD
     *
     * @return List de tous les objets Locations
     */
    public List getAll() {
        List<Location> locationList = new ArrayList();
        String[] columnArray = {
                DatabaseStaticVariables.LOCATION_LATITUDE + "," + DatabaseStaticVariables.LOCATION_LONGITUDE + "," +
                        DatabaseStaticVariables.LOCATION_TIMESTAMP + "," + DatabaseStaticVariables.LOCATION_ALTITUDE + "," +
                        DatabaseStaticVariables.LOCATION_IS_SYNC};
        Cursor cursor = db.query(DatabaseStaticVariables.LOCATION_TABLE_NAME,
                columnArray, null, null, null, null, null, null);

        if (cursor.getCount() > 0) {
            cursor.moveToFirst();
            do {
                Location location = new Location();
                location.setLatitude(cursor.getDouble(cursor.getColumnIndex(DatabaseStaticVariables.LOCATION_LATITUDE)));
                location.setLongitude(cursor.getDouble(cursor.getColumnIndex(DatabaseStaticVariables.LOCATION_LONGITUDE)));
                location.setTimestamp(cursor.getInt(cursor.getColumnIndex(DatabaseStaticVariables.LOCATION_TIMESTAMP)));
                location.setAltitude(cursor.getDouble(cursor.getColumnIndex(DatabaseStaticVariables.LOCATION_ALTITUDE)));
                location.setIsSync(cursor.getInt(cursor.getColumnIndex(DatabaseStaticVariables.LOCATION_IS_SYNC)));
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
