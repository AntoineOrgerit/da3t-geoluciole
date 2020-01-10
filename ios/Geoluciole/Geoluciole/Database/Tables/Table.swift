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

    func selectQuery(_ wantedColumns: [String] = [], where whereConditions: [WhereCondition]? = nil) -> Dictionary<AnyHashable, Any> {
        var queryResult = [AnyHashable: Any]()

        var sql = wantedColumns.isEmpty ? "SELECT *" : "SELECT " + Tools.joinWithCharacter(",", wantedColumns)
        sql += " FROM " + self.tableName

        if let whereConditions = whereConditions, !whereConditions.isEmpty {
            sql += " WHERE"

            var allConditions = [String]()
            for whereCondition in whereConditions {
                allConditions.append(whereCondition.toString())
            }
        }

        self.db.open()
        do {
            if let r = try self.db.executeQuery(sql, values: nil).resultDictionary {
                queryResult = r
            }
        } catch let error {
            print("SELECT ERROR : \(error.localizedDescription)")
        }
        
        self.db.close()
        
        return queryResult
    }

    func insertQuery(_ arguments: [String: Any]) {

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
}
