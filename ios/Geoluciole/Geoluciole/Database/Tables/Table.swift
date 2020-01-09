//
//  Table.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class Table {

    var tableName: String = ""
    var columns: [TableColumn] = []
    fileprivate let db = DatabaseManager.getInstance()

    func prepareSQLForCreateTable() -> String {
        var sqlRequest = "CREATE TABLE IF NOT EXISTS"
        sqlRequest += " " + self.tableName + "("

        let endIndex = self.columns.count - 1
        for i in 0...endIndex {

            let column = self.columns[i]

            sqlRequest += " " + column.columnName
            sqlRequest += " " + column.columnType

            if !column.canBeNull {
                sqlRequest += " NOT NULL"
            }

            if i != columns.count - 1 {
                sqlRequest += ","
            }
        }

        sqlRequest += " );"

        return sqlRequest
    }

    //TODO: QUERY
    func select(_ arguments: [String: Any]) {

    }

    //TODO: UPDATE

    func insert(_ arguments: [String: Any]) {

        var sql = "INSERT INTO " + self.tableName + " ("
        var sqlValues = ""
        var allKeys = [String]()

        for key in arguments.keys {
            allKeys.append(key)
        }

        sqlValues += Tools.joinWithCharacter(":", ",", allKeys)
        sql += Tools.joinWithCharacter(nil, ",", allKeys) + ") VALUES (" + sqlValues + ")"

        self.db.open()
        let success = self.db.executeUpdate(sql, withParameterDictionary: arguments)
        self.db.close()
        if !success {
            print("Error insert " + self.tableName + " : " + self.db.lastErrorMessage())
        }
    }

    //TODO: DROP
}
