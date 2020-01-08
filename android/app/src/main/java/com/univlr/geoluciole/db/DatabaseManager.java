package com.univlr.geoluciole.db;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

/**
 * DatabaseManager - herite de la classe SQLiteOpenHelper
 * Permet de gerer la base de donnees selon les evenements du systeme
 */
public class DatabaseManager extends SQLiteOpenHelper {
    // instance singleton de la base de donnees
    private static DatabaseManager sInstance;
    // version de la base de donnees
    private static final int DATABASE_VERSION = 2;
    // nom de la base de donnees
    private static final String DATABASE_NAME = "geoluciole";

    // requete de creation de la table location
    public static final String LOCATION_TABLE_CREATE =
            "CREATE TABLE " + DatabaseStaticVariables.LOCATION_TABLE_NAME + " (" +
                    DatabaseStaticVariables.LOCATION_LONGITUDE + " REAL, " +
                    DatabaseStaticVariables.LOCATION_LATITUDE + " REAL, " +
                    DatabaseStaticVariables.LOCATION_TIMESTAMP + " INTEGER, " +
                    DatabaseStaticVariables.LOCATION_ALTITUDE + " REAL, " +
                    DatabaseStaticVariables.LOCATION_IS_SYNC + " INTEGER);";

    // requete de suppression de la table location
    public static final String LOCATION_TABLE_DROP = "DROP TABLE IF EXISTS " + DatabaseStaticVariables.LOCATION_TABLE_NAME + ";";

    /**
     * Singleton DatabaseManager
     *
     * @param context
     * @return DatabaseManager
     */
    public static synchronized DatabaseManager getInstance(Context context) {
        if (sInstance == null) {
            sInstance = new DatabaseManager(context.getApplicationContext());
        }
        return sInstance;
    }

    /**
     * Constructeur prive de la classe, utilise le contexte passe en parametre,
     * le nom de la base, null pour la factory, et la version de la base de donnees
     *
     * @param context
     */
    private DatabaseManager(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    /**
     * Premiere fois ou on manipule la base de donnees,
     * Premier deploiement de l'application
     * Permet de creer la base de donnees
     *
     * @param db la base de donnees SQLite
     */
    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(LOCATION_TABLE_CREATE);
        Log.i("DATABASE", "onCreate invoked");
    }

    /**
     * Suppression de l ancienne base de donnees
     * Mise en place de la nouvelle base de donnees
     *
     * @param db         la base de donnees SQLite
     * @param oldVersion ancienne version de la base
     * @param newVersion nouvelle version de la base
     */
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL(LOCATION_TABLE_DROP);
        Log.i("DATABASE", "onUpgrade invoked");
        onCreate(db);

    }
}
