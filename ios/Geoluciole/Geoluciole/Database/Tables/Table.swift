//
//  Table.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class Table {
    // Définition des types de retour possible pour les actions de la BDD
    // Retour 1 : Indication état de la requête + erreur
    public typealias Completion = ((Bool, Error?) -> Void)

    // Retour 2 : Idem retour 1 mais avec des résultats à retourner
    public typealias ResultCompletion = ((Bool, [[String: Any]], Error?) -> Void)

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

    func selectQuery(_ wantedColumns: [String] = [], where whereConditions: [WhereCondition]? = nil, completion: ResultCompletion) {
        DatabaseManager.sharedQueue.inDeferredTransaction { (db, rollback) in
            do {
                var queryResult = [[String: Any]]()
                var sql = wantedColumns.isEmpty ? "SELECT *" : "SELECT " + Tools.joinWithCharacter(",", wantedColumns)
                sql += " FROM " + self.tableName

                var values = [Any]()
                if let whereConditions = whereConditions, !whereConditions.isEmpty {
                    sql += " WHERE"
                    for (index, condition) in whereConditions.enumerated() {
                        values.append(condition.value!)
                        sql += " " + condition.column + " = ?"
                        sql += (index == whereConditions.count - 1) ? "" : ","
                    }
                }

                if !self.db.isOpen {
                    self.db.open()
                }

                let result = try self.db.executeQuery(sql, values: values)

                while result.next() {
                    var data = [String: Any]()
                    for (key, value) in result.resultDictionary! {
                        data[key as! String] = value
                    }

                    queryResult.append(data)
                }

                completion(true, queryResult, nil)
                self.db.close()
            } catch {
                print("SELECT ERROR " + self.tableName + " : " + error.localizedDescription)
                completion(false, [], error)
                self.db.close()
            }
        }
    }

    func insertQuery(_ arguments: [String: Any]) {
        DatabaseManager.sharedQueue.inDeferredTransaction { (db, rollback) in
            var sql = "INSERT INTO " + self.tableName + " ("
            var sqlValues = ""
            var allKeys = [String]()

            for key in arguments.keys {
                allKeys.append(key)
            }

            sqlValues += Tools.joinWithCharacter(":", ",", allKeys)
            sql += Tools.joinWithCharacter(nil, ",", allKeys) + ") VALUES (" + sqlValues + ")"

            do {
                if !self.db.isOpen {
                    self.db.open()
                }

                let success = self.db.executeUpdate(sql, withParameterDictionary: arguments)

                if !success {
                    print("INSERT ERROR " + self.tableName + " : " + self.db.lastErrorMessage())
                }

                self.db.close()
            }
        }
    }

    func deleteQuery() {
        DatabaseManager.sharedQueue.inDeferredTransaction { (db, rollback) in
            do {
                if !self.db.isOpen {
                    self.db.open()
                }

                let sql = "DELETE FROM " + self.tableName
                try self.db.executeUpdate(sql, values: [])
                self.db.close()
            } catch {
                print("DELETE ERROR " + self.tableName + " : " + error.localizedDescription)
                self.db.close()
            }
        }
    }
}
