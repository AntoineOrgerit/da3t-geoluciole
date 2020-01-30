//Copyright (c) 2020, Martin Allusse and Alexandre Baret and Jessy Barritault and Florian
//Bertonnier and Lisa Fougeron and François Gréau and Thibaud Lambert and Antoine
//Orgerit and Laurent Rayez
//All rights reserved.
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:
//
//* Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//* Neither the name of the copyright holders nor the names of its
//  contributors may be used to endorse or promote products derived
//  from this software without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
//EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
//DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import Foundation
import UIKit

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
        self.timer = Timer(timeInterval: Constantes.TIMER_SEND_DATA, target: self, selector: #selector(sendPostLocationTimer), userInfo: nil, repeats: true)
        self.timer?.tolerance = 60.0 // (en s) ajout d'une tolérance pour permettre d'effectuer l'action dans une intervalle étendue
        RunLoop.current.add(self.timer!, forMode: .common)
    }

    // Retire l'action de déclenchement d'envoi des données de localisation au serveur
    func stopTimerLocation() {
        self.timer?.invalidate()
    }

    // Envoi serveur PART
    /// Envoi les données de localisation de façon périodique au serveur
    @objc func sendPostLocationTimer() {
        sendPostLocationElasticSearch()
    }

    /// Envoi les données de localisation de l'utilisateur au serveur
    func sendPostLocationElasticSearch(viewController: ParentViewController? = nil) {
        if Constantes.DEBUG {
            print("Timer déclenché")
        }

        // création du message à envoyer

        // récupération des localisations en BDD SQLite
        LocationTable.getInstance().selectQuery { (success, result, error) in
            if result.count > 0 {
                var locations = [[String: Any]]()

                // Pour chaque instance récupérée, on crée un objet Location associé que l'on ajoute dans un tableau
                for location in result {
                    let loc = Location(latitude: location[LocationTable.LATITUDE] as! Double, longitude: location[LocationTable.LONGITUDE] as! Double, altitude: location[LocationTable.ALTITUDE] as! Double, timestamp: location[LocationTable.TIMESTAMP] as! Double, precision: location[LocationTable.PRECISION] as! Double, vitesse: location[LocationTable.VITESSE] as! Double, date_str: location[LocationTable.DATE] as! String)

                    locations.append(loc.toDictionary())
                }

                // Si le tableau n'est pas vide, on envoi notre message
                if locations.count > 0 {
                    let message: String = ElasticSearchAPI.getInstance().generateMessage(content: locations, needBulk: true, addInfoDevice: false)
                    ElasticSearchAPI.getInstance().postLocations(message: message, viewController: viewController)
                }
            } else {
                DispatchQueue.main.async {
                    viewController?.rootView.hideAllToasts()
                    viewController?.rootView.makeToast(Tools.getTranslate(key: "toast_no_data_send"), duration: 2)
                }
            }
        }
    }
}
