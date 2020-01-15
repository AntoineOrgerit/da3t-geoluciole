//
// Created by Alexandre BARET on 10/01/2020.
// Copyright (c) 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class ElasticSearchAPI {

    fileprivate let resourceURL: URL
    fileprivate static var INSTANCE: ElasticSearchAPI!

    init() {
        guard let resourceURL = URL(string: Constantes.API_URL_UNIV_LR) else {
            fatalError()
        }

        self.resourceURL = resourceURL
    }

    static func getInstance() -> ElasticSearchAPI {
        if INSTANCE == nil {
            INSTANCE = ElasticSearchAPI()
        }

        return INSTANCE
    }

    /// Génération du message à envoyer au serveur
    func generateMessage(locations: [Location], identifier: String) -> String {
        var messageStr = ""

        // On génère une string exemple pour l'index
        let index = "{\"index\": {}}"
        let idStr = "\"id\": \"\(identifier)\""

        for location in locations {
            if location.toString() != "" {
                messageStr += index + "\n"
                messageStr += location.toString() + ", \(idStr)}\n"
            }

        }

        return messageStr
    }

    /// Envoi des localisations du terminal au serveur
    func postLocations(message: String) {
        NSLog("Envoi au serveur en cours ...")
        // Création de la requête (header + contenu)
        var request = URLRequest(url: resourceURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = message.data(using: .utf8)

        // création de la tâche d'envoi
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Si on récupère pas d'information d'erreur et que l'on a pas de données, on indique
            // que l'on a reçu aucune donnée
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }

            // Sinon, on récupère le
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                // si on a pas d'erreurs, on supprime les données en base
                if let err = responseJSON["errors"] as? Int {
                    if err == 0 {
                        NSLog("Envoi au serveur réussi !")
                        LocationTable.getInstance().deleteQuery()
                        // Sinon, on indique l'erreur et on garde les données
                    } else {
                        NSLog("Erreur durant l'envoi au serveur")
                    }
                }

            }
        }

        // mise en file d'attente de la tâche
        task.resume()
    }
}
