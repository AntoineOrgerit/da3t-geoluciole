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

    static let DB_NAME = "geoluciole.sqlite"

    // Il faut incrémenter lorsque l'on veut prendre en compte des modifs pour la base de données et faire le nécessaire dans la fonction upgradeDatabase de la classe DatabaseManager
    static let DB_VERSION = 1

    static let TITLE_BAR_PADDING_HORIZONTAL: CGFloat = 10
    static let PAGE_PADDING_HORIZONTAL: CGFloat = 10
    static let FIELD_SPACING_HORIZONTAL: CGFloat = 10
    static let FIELD_SPACING_VERTICAL: CGFloat = 20

    // SERVEUR ELASTIC SEARCH
    static let API_URL_UNIV_LR = "http://datamuseum.univ-lr.fr:80/geolucioles/data/_bulk"
    static let API_URL_SERVER_TEST = "http://86.233.189.163:9200/geolucioles/data/_bulk"
    static let TIMER_SEND_DATA = 10.0 // en s ==> paramètre pour l'envoi régulier au serveur
}
