//
//  Constantes.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Constantes {

    // Mettre a TRUE si on veut afficher les logs
    static let DEBUG = true

    static let DB_NAME = "geoluciole.sqlite"
    static let CGU_NAME = "cgu.pdf"
    static let BADGES_FILENAME = "badges.json"

    static let REVOQ_CONSENT_MAIL = "Melanie.mondo1@univ-lr.fr"
    // Il faut incrémenter lorsque l'on veut prendre en compte des modifs pour la base de données et faire le nécessaire dans la fonction upgradeDatabase de la classe DatabaseManager
    static let DB_VERSION = 1

    static let TITLE_BAR_PADDING_HORIZONTAL: CGFloat = 10
    static let PAGE_PADDING: CGFloat = 10
    static let FIELD_SPACING_HORIZONTAL: CGFloat = 10
    static let FIELD_SPACING_VERTICAL: CGFloat = 15
    static let LOADER_SIZE: CGFloat = 50

    // SERVEUR ELASTIC SEARCH
    static let API_URL_UNIV_LR_HTTP = "http://datamuseum.univ-lr.fr:9200"
    static let API_URL_UNIV_LR_HTTPS = "https://datamuseum.univ-lr.fr:9200"
    static let SECONDE: Double = 1.0 //
    static let MINUTE: Double = SECONDE * 60.0
    static let HEURE: Double = MINUTE * 60.0 // en secondes
    static let TIMER_SEND_DATA: Double = HEURE * 4.0 // en secondes ==> paramètre pour l'envoi régulier au serveur (ici 4h : 3600s * 4 = 4h)

    // DISTANCE DE DETECTION
    static let DISTANCE_DETECTION: CLLocationDistance = 10.0
}
