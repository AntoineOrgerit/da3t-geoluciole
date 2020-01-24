//
// Created by Alexandre BARET on 10/01/2020.
// Copyright (c) 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

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
    func generateMessage(locations: [Location], identifier: Int) -> String {
        var messageStr = ""

        // On génère une string exemple pour l'index
        let index = "{\"index\": {}}"
        let idStr = "\"id_user\": \(identifier)"

        for location in locations {
            if location.toString() != "" {
                messageStr += index + "\n"
                messageStr += location.toString() + ", \(idStr)}\n"
            }

            
        }

        return messageStr
    }

    /// Envoi des localisations du terminal au serveur
    func postLocations(message: String, viewController: UIViewController? = nil) {
        if Constantes.DEBUG {
            print("Envoi des données de localisation au serveur en cours ...")
        }

        DispatchQueue.main.async {
            viewController?.view.makeToast("Envoi des données en cours...", duration: 10, position: .bottom)
        }

        // Création de la requête (header + contenu)
        var request = URLRequest(url: resourceURL.appendingPathComponent("/da3t_gps/_doc/_bulk"))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = message.data(using: .utf8)

        // création de la tâche d'envoi
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Si on récupère pas d'information d'erreur et que l'on a pas de données, on indique
            // que l'on a reçu aucune donnée
            guard let data = data, error == nil else {
                if Constantes.DEBUG {
                    print(error?.localizedDescription ?? "No data")
                }
                return
            }

            // Sinon, on récupère le
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                // si on a pas d'erreurs, on supprime les données en base
                if let err = responseJSON["errors"] as? Int {
                    if err == 0 {
                        if Constantes.DEBUG {
                            print("Envoi des données de localisation au serveur réussi !")
                        }

                        LocationTable.getInstance().deleteQuery()

                        DispatchQueue.main.async {
                            viewController?.view.hideAllToasts()

                            var style = ToastStyle()
                            style.backgroundColor = UIColor(red: 145 / 255, green: 208 / 255, blue: 182 / 255, alpha: 0.9)
                            viewController?.view.makeToast("Envoi des données réussi !", duration: 1, position: .bottom, style: style)
                        }

                        // Sinon, on indique l'erreur et on garde les données
                    } else {
                        if Constantes.DEBUG {
                            print("Erreur durant l'envoi des données de localisation au serveur")
                        }
                    }
                }
            }
        }

        // mise en file d'attente de la tâche
        task.resume()
    }

    /// Génération du message à envoyer au serveur
    func generateMessageCompte() -> String {
        let type = "\"type\": \"\(UIDevice.current.systemName)\""
        let version = "\"version\": \"\(UIDevice.current.systemVersion)\""
        let device = "\"device\": \"\(UIDevice.modelName)\""
        
        NSLog(type + ", " + version + ", " + device)
        
        let messageStr = "{\"consentement\":\"\(NSLocalizedString("rgpd_first_content_consentement", comment: ""))\", \"date\":\"\(Tools.convertDate(date: Date()))\", \"nom\":\"test2\", \"prenom\": \"test2\", \"mail\": \"mail2@gmail.com\", \(device), \(version), \(device)}"

        return messageStr
    }

    /// Envoi des localisations du terminal au serveur
    func postCompte(message: String) {
        if Constantes.DEBUG {
            print("Envoi des données de compte au serveur en cours ...")
        }

        let id = UserPrefs.getInstance().string(forKey: "KEY_IDENTIFIER")
        var request = URLRequest(url: resourceURL.appendingPathComponent("/da3t_compte/_doc/\(id)"))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = message.data(using: .utf8)

        // création de la tâche d'envoi
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Si on récupère pas d'information d'erreur et que l'on a pas de données, on indique
            // que l'on a reçu aucune donnée
            guard let data = data, error == nil else {
                if Constantes.DEBUG {
                    print(error?.localizedDescription ?? "No data")
                }
                return
            }

            // Sinon, on récupère le
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                // si on a pas d'erreurs, on supprime les données en base
                if let err = responseJSON["_shards"] as? [String: Int] {
                    if err["failed"] == 0 {
                        if Constantes.DEBUG {
                            print("Envoi des données de compte au serveur réussi !")
                        }
                        // Sinon, on indique l'erreur et on garde les données
                    } else {
                        if Constantes.DEBUG {
                            print("Erreur durant l'envoi des données de compte au serveur")
                        }
                    }
                }

            }
        }

        // mise en file d'attente de la tâche
        task.resume()
    }
}
