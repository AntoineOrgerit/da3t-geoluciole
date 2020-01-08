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

            if let defaultValue = column.defaultValue {
                sqlRequest += " DEFAULT \(defaultValue)"
            }

            if i != columns.count - 1 {
                sqlRequest += ","
            }
        }

        sqlRequest += " );"

        return sqlRequest
    }
}
