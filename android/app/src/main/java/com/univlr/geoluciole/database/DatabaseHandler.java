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
    private static final String TAG = "DatabaseHandler : ";
    // instance singleton de la base de données
    private static DatabaseHandler sInstance;
    // version de la base de données
    private static final int DATABASE_VERSION = 9;
    // nom de la base de données
    private static final String DATABASE_NAME = "geoluciole";
    // tables de la base de données
    private final Table[] myTables = {new LocationTable()};
    // base de données
    private SQLiteDatabase db;

    /**
     * Singleton DatabaseManager
     *
     * @param context Context
     * @return DatabaseManager
     */
    public static synchronized DatabaseHandler getInstance(Context context) {
        if (sInstance == null) {
            sInstance = new DatabaseHandler(context.getApplicationContext());
        }
        return sInstance;
    }

    /**
     * Constructeur privé de la classe, utilise le contexte passé en parametre,
     * le nom de la base, null pour la factory, et la version de la base de données
     *
     * @param context Context
     */
    private DatabaseHandler(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    /**
     * Première fois où on manipule la base de données,
     * Premier déploiement de l'application
     * Permet de créer la base de données
     *
     * @param db SQLiteDatabase la base de données SQLite
     */
    @Override
    public void onCreate(SQLiteDatabase db) {
        Log.i(TAG, "onCreate invoked");
        createAllTables(db, myTables);
    }

    /**
     * Permet de créer toutes les tables passées en paramètres via le tableau Table[]
     *
     * @param db     SQLiteDatabase la base données
     * @param tables Table[]
     */
    private void createAllTables(SQLiteDatabase db, Table[] tables) {
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
    private void deleteAllTables(SQLiteDatabase db, Table[] tables) {
        for (Table t : tables) {
            db.execSQL(t.prepareSQLForDeleteTable());
        }
    }

    /**
     * Suppression de l'ancienne base de données
     * Mise en place de la nouvelle base de données
     *
     * @param db         SQLiteDatabase la base de données
     * @param oldVersion ancienne version de la base
     * @param newVersion nouvelle version de la base
     */
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        Log.d(TAG, "onUpgrade");
        deleteAllTables(db, myTables);
        onCreate(db);
    }

    /**
     * Ouverture de la BDD en écriture
     */
    public void open() {
        db = this.getWritableDatabase();
        Log.i(TAG, "Ouverture de la base de données en écriture");
    }

    /**
     * Fermeture de la BDD
     */
    public void close() {
        db.close();
        Log.i(TAG, "Fermeture de la base de données en écriture");
    }

    /**
     * Getter de la base de données
     *
     * @return SQLiteDatabase la base de données
     */
    public SQLiteDatabase getDb() {
        return db;
    }

}
