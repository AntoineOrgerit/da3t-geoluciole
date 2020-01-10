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

    init(columnName: String, columnType: String, canBeNull: Bool) {
        self.columnName = columnName
        self.columnType = columnType
        self.canBeNull = canBeNull
    }
}
