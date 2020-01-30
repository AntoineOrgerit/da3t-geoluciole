//    Copyright (c) 2020, Martin Allusse and Alexandre Baret and Jessy Barritault and Florian
//    Bertonnier and Lisa Fougeron and François Gréau and Thibaud Lambert and Antoine
//    Orgerit and Laurent Rayez
//    All rights reserved.
//    Redistribution and use in source and binary forms, with or without
//    modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright
//      notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//    * Neither the name of the University of California, Berkeley nor the
//      names of its contributors may be used to endorse or promote products
//      derived from this software without specific prior written permission.
//
//    THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
//    EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//    DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
//    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
