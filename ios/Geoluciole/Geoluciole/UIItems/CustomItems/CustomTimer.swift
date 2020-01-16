//
//  CustomTimer.swift
//  Geoluciole
//
//  Created by Alexandre BARET on 15/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation


class CustomTimer {

    fileprivate static var INSTANCE: CustomTimer!
    fileprivate var timer: Timer?

    fileprivate init() {

    }

    static func getInstance() -> CustomTimer {
        if INSTANCE == nil {
            INSTANCE = CustomTimer()
        }

        return INSTANCE
    }

    // Lancement du timer pour déclencher l'envoi des données de localisation au serveur
    func startTimerLocalisation() {
        self.timer = Timer(timeInterval: Constantes.TIMER_SEND_DATA, target: self, selector: #selector(sendPostElasticSearch), userInfo: nil, repeats: true)
        self.timer?.tolerance = 60.0 // (en s) ajout d'une tolérance pour permettre d'effectuer l'action dans une intervalle étendue
        RunLoop.current.add(self.timer!, forMode: .common)
    }

    // Retire l'action de déclenchement d'envoi des données de localisation au serveur
    func stopTimerLocation() {
        self.timer?.invalidate()
    }

    // Envoi serveur PART

    /// Envoi les données de localisation de l'utilisateur au serveur
    @objc func sendPostElasticSearch() {
        if Constantes.DEBUG {
            print("Timer déclenché")
        }
        
        // création du message à envoyer

        // récupération des localisations en BDD SQLite
        LocationTable.getInstance().selectQuery { (success, result, error) in
            if result.count > 0 {
                var locations: [Location] = [Location]()

                // Pour chaque instance récupérée, on crée un objet Location associé que l'on ajoute dans un tableau
                for location in result {
                    let loc = Location(latitude: location[LocationTable.LATITUDE] as! Double, longitude: location[LocationTable.LONGITUDE] as! Double, altitude: location[LocationTable.ALTITUDE] as! Double, timestamp: location[LocationTable.TIMESTAMP] as! Double)

                    locations.append(loc)
                }

                // Si le tableau n'est pas vide, on envoi notre message
                if locations.count > 0 {
                    let identifier = Tools.getIdentifier()

                    let message: String = ElasticSearchAPI.getInstance().generateMessage(locations: locations, identifier: identifier)
                    ElasticSearchAPI.getInstance().postLocations(message: message)
                }
            }
        }
    }
}
