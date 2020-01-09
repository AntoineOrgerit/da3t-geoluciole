//
//  LocationTable.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class LocationTable: Table {

    fileprivate static var INSTANCE: LocationTable!

    static let LATITUDE = "latitude"
    static let LONGITUDE = "longitude"
    static let ALTITUDE = "altitude"
    static let TIMESTAMP = "time_stamp"

    fileprivate override init() {
        super.init()

        self.tableName = "locations"
        self.columns = [
            TableColumn(columnName: LocationTable.LATITUDE, columnType: "DOUBLE", canBeNull: false),
            TableColumn(columnName: LocationTable.LONGITUDE, columnType: "DOUBLE", canBeNull: false),
            TableColumn(columnName: LocationTable.ALTITUDE, columnType: "DOUBLE", canBeNull: false),
            TableColumn(columnName: LocationTable.TIMESTAMP, columnType: "TIMESTAMP", canBeNull: false)
        ]
    }
    
    static func getInstance() -> LocationTable {
        if INSTANCE == nil {
            INSTANCE = LocationTable()
        }
        
        return INSTANCE
    }
}
