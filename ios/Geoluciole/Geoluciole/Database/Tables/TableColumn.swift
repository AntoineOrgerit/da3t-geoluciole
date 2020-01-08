//
//  TableColumn.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class TableColumn {
    
    var columnName: String!
    var columnType: String!
    var canBeNull: Bool!
    var defaultValue: Any?

    init(columnName: String, columnType: String, canBeNull: Bool, defaultValue: Any? = nil) {
        self.columnName = columnName
        self.columnType = columnType
        self.canBeNull = canBeNull
        self.defaultValue = defaultValue
    }
}
