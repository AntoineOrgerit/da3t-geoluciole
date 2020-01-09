//
//  Location.swift
//  Geoluciole
//
//  Created by Alexandre BARET on 09/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class Location {
    
    let latitude: Double
    let longitude: Double
    let altitude: Double
    let timestamp: Date
    let isSync: Bool
    
    init(latitude: Double, longitude: Double, altitude: Double, timestamp: Date, isSync: Bool) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.timestamp = timestamp
        self.isSync = isSync
    }
}
