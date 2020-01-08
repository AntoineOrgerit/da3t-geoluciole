//
//  LocationTable.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class LocationTable: Table {
    
    override init() {
        super.init()
        
        self.tableName = "locations"
        self.columns = [
            TableColumn(columnName: "latitude", columnType: "DOUBLE", canBeNull: false),
            TableColumn(columnName: "longitude", columnType: "DOUBLE", canBeNull: false),
            TableColumn(columnName: "altitude", columnType: "DOUBLE", canBeNull: false),
            TableColumn(columnName: "time_stamp", columnType: "TIMESTAMP", canBeNull: false),
            TableColumn(columnName: "is_sync", columnType: "BOOLEAN", canBeNull: false, defaultValue: 0)
        ]
    }
}
