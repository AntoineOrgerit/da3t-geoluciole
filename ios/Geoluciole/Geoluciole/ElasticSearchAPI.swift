//
// Created by Alexandre BARET on 10/01/2020.
// Copyright (c) 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class ElasticSearchAPI {

    fileprivate let resourceURL: URL
    fileprivate static var INSTANCE: ElasticSearchAPI!

    init() {
        guard let resourceURL = URL(string: Constantes.API_URL) else {
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

    /// Envoi des localisations du terminal au serveur
    func postLocations(_ message: ElasticSearchAPIMessage) {
        // transformation de l'objet en JSON
        let jsonData = try? JSONEncoder().encode(message)
        let jsonString = String(data: jsonData!, encoding: String.Encoding.utf8)
        print(jsonString!)

        // Création de la requête (header + contenu)
        var request = URLRequest(url: resourceURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

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
                print(responseJSON)
            }
        }

        // mise en file d'attente de la tâche
        task.resume()
    }
}
