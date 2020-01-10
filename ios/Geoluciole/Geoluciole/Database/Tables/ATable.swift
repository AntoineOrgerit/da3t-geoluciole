//
//  ATable.swift
//  Geoluciole
//
//  Created by local192 on 10/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class ATable: Table {

    fileprivate static var INSTANCE: ATable!

    fileprivate override init() {
        super.init()

        self.tableName = "atable"
        self.columns = [
            TableColumn(columnName: LocationTable.LATITUDE, columnType: "DOUBLE", canBeNull: false),
            TableColumn(columnName: LocationTable.LONGITUDE, columnType: "DOUBLE", canBeNull: false),
            TableColumn(columnName: LocationTable.ALTITUDE, columnType: "DOUBLE", canBeNull: false),
            TableColumn(columnName: LocationTable.TIMESTAMP, columnType: "TIMESTAMP", canBeNull: false)
        ]
    }
    
    static func getInstance() -> ATable {
        if INSTANCE == nil {
            INSTANCE = ATable()
        }
        
        return INSTANCE
    }
}
