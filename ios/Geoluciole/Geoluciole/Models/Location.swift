//
//  Location.swift
//  Geoluciole
//
//  Created by Alexandre BARET on 09/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class Location: Codable {
    
    var latitude: Double!
    var longitude: Double!
    var altitude: Double!
    var timestamp: Double!
    
    init() {
        // pas d'initialisation
    }
}
