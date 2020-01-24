package com.univlr.geoluciole.database;

/**
 * Classe TableColumn
 */
class TableColumn {
    private String columnName;
    private String columnType;
    private boolean canBeNull;

    /**
     * Constructeur de la classe
     *
     * @param columnName String nom de la colonne
     * @param columnType String type de la colonne
     * @param canBeNull  boolean si null est a 1 sinon 0
     */
    TableColumn(String columnName, String columnType, boolean canBeNull) {
        this.columnName = columnName;
        this.columnType = columnType;
        this.canBeNull = canBeNull;
    }

    String getColumnName() {
        return columnName;
    }

    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    String getColumnType() {
        return columnType;
    }

    public void setColumnType(String columnType) {
        this.columnType = columnType;
    }

    boolean isCanBeNull() {
        return canBeNull;
    }

    public void setCanBeNull(boolean canBeNull) {
        this.canBeNull = canBeNull;
    }
}
