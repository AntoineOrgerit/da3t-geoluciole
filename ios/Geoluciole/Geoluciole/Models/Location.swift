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
    var date_str: String

    init(latitude: Double, longitude: Double, altitude: Double, timestamp: Double, precision: Double, vitesse: Double, date_str: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.timestamp = timestamp
        self.precision = precision
        self.vitesse = vitesse
        self.date_str = date_str
    }

    init(_ dict: [String: Any]) {
        self.latitude = dict["latitude"] as! Double
        self.longitude = dict["longitude"] as! Double
        self.altitude = dict["altitude"] as! Double
        self.timestamp = dict["timestamp"] as! Double
        self.precision = dict["precision"] as! Double
        self.vitesse = dict["vitesse"] as! Double
        self.date_str = dict["date_str"] as! String
    }

    /// Fonction utilisée pour l'envoi des données au serveur
    func toString() -> String {
        return "{\"latitude\": \(latitude), \"longitude\": \(longitude), \"altitude\": \(altitude), \"timestamp\": \(timestamp), \"precision\": \(precision), \"vitesse\": \(vitesse), \"date_str\": \(date_str)"
    }

    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["latitude"] = self.latitude
        dict["longitude"] = self.longitude
        dict["altitude"] = self.altitude
        dict["timestamp"] = self.timestamp
        dict["precision"] = self.precision
        dict["vitesse"] = self.vitesse
        dict["date_str"] = self.date_str
        return dict
    }
}
