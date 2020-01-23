//
//  Constantes.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

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

    static let API_URL_UNIV_LR = "http://datamuseum.univ-lr.fr:80"
    static let API_URL_SERVER_TEST_JESSY = "http://86.233.189.163:9200"
    static let TIMER_SEND_DATA = 60.0 * 2 // en s ==> paramètre pour l'envoi régulier au serveur

}
