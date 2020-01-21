package com.univlr.geoluciole.database;


import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;


/**
 * DatabaseManager - herite de la classe SQLiteOpenHelper
 * Permet de gerer la base de donnees selon les evenements du systeme
 */
public class DatabaseHandler extends SQLiteOpenHelper {
    // instance singleton de la base de donnees
    private static DatabaseHandler sInstance;
    // version de la base de donnees
    private static final int DATABASE_VERSION = 8;
    // nom de la base de donnees
    private static final String DATABASE_NAME = "geoluciole";
    // tables de la base de donnees
    private Table[] myTables = {new LocationTable()};
    // base de donnees
    private SQLiteDatabase db;

    /**
     * Singleton DatabaseManager
     *
     * @param context
     * @return DatabaseManager
     */
    public static synchronized DatabaseHandler getInstance(Context context) {
        if (sInstance == null) {
            sInstance = new DatabaseHandler(context.getApplicationContext());
        }
        return sInstance;
    }

    /**
     * Constructeur prive de la classe, utilise le contexte passe en parametre,
     * le nom de la base, null pour la factory, et la version de la base de donnees
     *
     * @param context
     */
    private DatabaseHandler(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    /**
     * Premiere fois ou on manipule la base de donnees,
     * Premier deploiement de l'application
     * Permet de creer la base de donnees
     *
     * @param db SQLiteDatabase la base de donnees SQLite
     */
    @Override
    public void onCreate(SQLiteDatabase db) {
        Log.i("DATABASE", "onCreate invoked");
        createAllTables(db, myTables);
    }

    /**
     * Permet de creer toutes les tables passees en parametres via le tableau Table[]
     *
     * @param db     SQLiteDatabase la base donnees
     * @param tables Table[]
     */
    public void createAllTables(SQLiteDatabase db, Table[] tables) {
        for (Table t : tables) {
            db.execSQL(t.prepareSQLForCreateTable());
        }
    }

    /**
     * Permet de supprimer toutes les tables via le tableau Table[]
     *
     * @param db     SQLiteDatabase la base de donnees
     * @param tables Table[]
     */
    public void deleteAllTables(SQLiteDatabase db, Table[] tables) {
        for (Table t : tables) {
            db.execSQL(t.prepareSQLForDeleteTable());
        }
    }

    /**
     * Suppression de l ancienne base de donnees
     * Mise en place de la nouvelle base de donnees
     *
     * @param db         SQLiteDatabase la base de donnees
     * @param oldVersion ancienne version de la base
     * @param newVersion nouvelle version de la base
     */
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        Log.i("DATABASE", "onUpgrade invoked");
        deleteAllTables(db, myTables);
        onCreate(db);
    }

    /**
     * Ouverture de la BDD en ecriture
     */
    public void open() {
        db = this.getWritableDatabase();
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
     * Getter de la base de donnees
     *
     * @return SQLiteDatabase la base de donnees
     */
    public SQLiteDatabase getDb() {
        return db;
    }

    public void read() {
        db = this.getReadableDatabase();
    }
}
