package com.univlr.geoluciole.database;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;


import java.util.List;

/**
 * Classe Table abstraite
 */
public abstract class Table {
    protected String tableName = "";
    // colonnes de la table
    protected TableColumn[] columns;

    protected DatabaseHandler dbSQLite;

    public Table() {
    }

    public Table(Context context) {
        dbSQLite = DatabaseHandler.getInstance(context);
    }

    /**
     * Permet de creer une table en base de donnees dynamiquement
     *
     * @return String la requete de creation
     */
    public String prepareSQLForCreateTable() {
        String sqlRequest = "CREATE TABLE IF NOT EXISTS";
        sqlRequest += " " + this.tableName + "(";

        int endIndex = this.columns.length;
        for (int i = 0; i < endIndex; i++) {

            TableColumn column = this.columns[i];

            sqlRequest += " " + column.getColumnName();
            sqlRequest += " " + column.getColumnType();

            if (!column.isCanBeNull()) {
                sqlRequest += " NOT NULL";
            }

            if (i != columns.length - 1) {
                sqlRequest += ",";
            }
        }
        sqlRequest += " );";
        return sqlRequest;
    }

    /**
     * Permet de supprimer une table en base de donnees
     *
     * @return String la requete de suppression
     */
    public String prepareSQLForDeleteTable() {
        return "DROP TABLE IF EXISTS " + this.tableName + ";";
    }

    /**
     * Permet d inserer un objet en base
     *
     * @param o Object a sauvegarder
     */
    public void insert(Object o) {
        this.dbSQLite.open();
        insertObject(o);
        this.dbSQLite.close();
    }

    /**
     * Permet d inserer un objet en base
     *
     * @param o Object a sauvegarder
     */
    protected abstract void insertObject(Object o);

    /**
     * Permet de supprimer tous les objets en base
     */
    public void removeAll() {
        this.dbSQLite.open();
        removeAllObject();
        this.dbSQLite.close();
    }

    /**
     * Permet de supprimer tous les objets en base
     */
    protected abstract void removeAllObject();

    /**
     * Permet de recuperer tous les objets de la base
     *
     * @return List des objets
     */
    public List getAll() {
        this.dbSQLite.open();
        List list = getAllObject();
        this.dbSQLite.close();
        return list;
    }

    /**
     * Permet de recuperer tous les objets de la base
     *
     * @return List des objets
     */
    protected abstract List getAllObject();
}
