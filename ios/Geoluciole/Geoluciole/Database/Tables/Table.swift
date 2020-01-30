//    Copyright (c) 2020, Martin Allusse and Alexandre Baret and Jessy Barritault and Florian
//    Bertonnier and Lisa Fougeron and François Gréau and Thibaud Lambert and Antoine
//    Orgerit and Laurent Rayez
//    All rights reserved.
//    Redistribution and use in source and binary forms, with or without
//    modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright
//      notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//    * Neither the name of the University of California, Berkeley nor the
//      names of its contributors may be used to endorse or promote products
//      derived from this software without specific prior written permission.
//
//    THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
//    EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//    DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
//    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
                        sql += (index == whereConditions.count - 1) ? "" : " and"
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
                if Constantes.DEBUG {
                    print("SELECT ERROR " + self.tableName + " : " + error.localizedDescription)
                }
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
                    if Constantes.DEBUG {
                        print("INSERT ERROR " + self.tableName + " : " + self.db.lastErrorMessage())
                    }
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
                if Constantes.DEBUG {
                    print("DELETE ERROR " + self.tableName + " : " + error.localizedDescription)
                }
                self.db.close()
            }
        }
    }

    func updateQuery(updateConditions:[UpdateConditions], where whereConditions: [WhereCondition]? = nil, completion: Completion) {

        var sql = "UPDATE " + self.tableName
        
        var values = [Any]()
        if !updateConditions.isEmpty {
            sql += " SET"
            for (index, condition) in updateConditions.enumerated() {
                values.append(condition.value!)
                sql += " " + condition.column + " = ?"
                sql += (index == updateConditions.count - 1) ? "" : ","
            }
        }
        
        if let whereConditions = whereConditions, !whereConditions.isEmpty {
            sql += " WHERE"
            for (index, condition) in whereConditions.enumerated() {
                values.append(condition.value!)
                sql += " " + condition.column + " = ?"
                sql += (index == whereConditions.count - 1) ? "" : " and"
            }
        }

        DatabaseManager.sharedQueue.inDeferredTransaction { (db, rollback) in
            do {
                if !self.db.isOpen {
                    self.db.open()
                }
                try self.db.executeUpdate(sql, values: values)
                completion(true, nil)
                self.db.close()
            } catch {
                print("failed: \(error.localizedDescription)")
                completion(false, error)
                self.db.close()
            }
        }
    }
}
