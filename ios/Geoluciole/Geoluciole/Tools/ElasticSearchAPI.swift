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
import UIKit

class ElasticSearchAPI {

    fileprivate var resourceURL: URL
    fileprivate static var INSTANCE: ElasticSearchAPI!

    init() {
        guard let resourceURL = URL(string: Constantes.API_URL_UNIV_LR_HTTP) else {
            fatalError("Erreur lors de la création de la ressource HTTP")
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
    func generateMessage(content: [[String: Any]], needBulk: Bool, addInfoDevice: Bool = false) -> String {
        var messageStr = ""
        let index = "{\"index\": {}}"
        let idStr = "\"id_user\": \(Tools.getIdentifier())"

        for element in content {
            if needBulk {
                messageStr += "\(index)\n"
            }

            // construction de l'élément à envoyer correspondant à notre dictionnaire
            var dictStr = ""
            messageStr += "{"
            for (key, value) in element {
                if let value = value as? String {
                    dictStr += "\"\(key)\": \"\(value)\", "
                } else {
                    dictStr += "\"\(key)\": \(value), "
                }
            }

            // Ajout du dict + de l'identifiant
            messageStr += dictStr + idStr

            // On ajoute les informations du device si demandé
            if addInfoDevice {
                let type = "\"type\": \"\(UIDevice.current.systemName)\""
                let version = "\"version\": \"\(UIDevice.current.systemVersion)\""
                let device = "\"device\": \"\(UIDevice.modelName)\""
                messageStr += ", \(type), \(version), \(device)"
            }

            messageStr += "}"

            if needBulk {
                messageStr += "\n"
            }
        }

        return messageStr
    }
    
    /// Génération du message de formulaire à envoyer au serveur
    func generateMessageFormulaire(content: [[String: Any]]) -> String {
        var messageStr = ""
        
        let index = "{\"index\": {}}"
        let idStr = "\"id_user\": \(Tools.getIdentifier())"

        for element in content {
            messageStr += "\(index)\n"

            // construction de l'élément à envoyer correspondant à notre dictionnaire
            var dictStr = ""
            messageStr += "{"
            for (key, value) in element {
                dictStr += "\"id_question\": \(key), \"reponse\": \"\(value)\", "
            }

            // Ajout du dict + de l'identifiant
            messageStr += dictStr + idStr

            messageStr += "}\n"
        }

        return messageStr
    }
    

    /// Envoi des données de localisation du terminal au serveur
    func postLocations(message: String, viewController: ParentViewController? = nil) {
        if Constantes.DEBUG {
            print("Envoi des données de localisation au serveur en cours ...")
        }

        DispatchQueue.main.async {
            viewController?.rootView.makeToast(Tools.getTranslate(key: "toast_send_data"), duration: 10, position: .bottom)
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
                            viewController?.rootView.makeToast(Tools.getTranslate(key: "toast_send_data_success"), duration: 1, position: .bottom, style: style)
                        }

                        // Sinon, on indique l'erreur et on garde les données
                    } else {
                        if Constantes.DEBUG {
                            print("Erreur durant l'envoi des données de localisation au serveur : \(String(describing: responseJSON["errors"]))")
                        }
                    }
                }
            }
        }

        // mise en file d'attente de la tâche
        task.resume()
    }

    /// Envoi des informations de compte au serveur
    func postCompte(message: String) {
        if Constantes.DEBUG {
            print("Envoi des données de compte au serveur en cours ...")
        }

        var request = URLRequest(url: resourceURL.appendingPathComponent("/da3t_compte/_doc/\(Tools.getIdentifier())"))
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

            // Sinon, on récupère le contenu de la réponse
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                if let shards = responseJSON["_shards"] as? [String: Any] {
                    if let err = shards["failed"] as? Int {
                        // Etat de l'envoi des données
                        if err == 0 {
                            if Constantes.DEBUG {
                                print("Envoi des données de compte au serveur réussi !")
                            }
                            // on supprime les données que l'on stockée en local sur le téléphone
                            UserPrefs.getInstance().removePrefs(key: UserPrefs.KEY_GPS_CONSENT_DATA)
                            UserPrefs.getInstance().removePrefs(key: UserPrefs.KEY_FORMULAIRE_CONSENT_DATA)
                        } else {
                            if Constantes.DEBUG {
                                print("Erreur durant l'envoi des données de compte au serveur")
                            }
                        }
                    }
                }
            }
        }

        // mise en file d'attente de la tâche
        task.resume()
    }
    
    /// Envoi des informations du formulaire au serveur
    func postFormulaire(message: String) {
        if Constantes.DEBUG {
                   print("Envoi des données du formulaire au serveur en cours ...")
               }

               // Création de la requête (header + contenu)
               var request = URLRequest(url: resourceURL.appendingPathComponent("/da3t_formulaire/_doc/_bulk"))
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
                                   print("Envoi des données du formulaire au serveur réussi !")
                               }

                               // Sinon, on indique l'erreur et on garde les données
                           } else {
                               if Constantes.DEBUG {
                                   print("Erreur durant l'envoi des données du formulaire au serveur : \(String(describing: responseJSON["errors"]))")
                               }
                           }
                       }
                   }
               }

               // mise en file d'attente de la tâche
               task.resume()
    }

}
