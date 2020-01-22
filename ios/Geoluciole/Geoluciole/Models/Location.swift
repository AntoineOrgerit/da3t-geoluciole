//
//  Location.swift
//  Geoluciole
//
//  Created by Alexandre BARET on 09/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class Location {
    
    var latitude: Double
    var longitude: Double
    var altitude: Double
    var timestamp: Double
    var precision: Double
    var vitesse: Double

    init(latitude: Double, longitude: Double, altitude: Double, timestamp: Double, precision: Double, vitesse: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.timestamp = timestamp
        self.precision = precision
        self.vitesse = vitesse
    }

    /// Fonction utilisée pour l'envoi des données au serveur
    func toString() -> String {
        return "{\"latitude\": \(latitude), \"longitude\": \(longitude), \"altitude\": \(altitude), \"timestamp\": \(timestamp), \"precision\": \(precision), \"vitesse\": \(vitesse)"
    }
}
