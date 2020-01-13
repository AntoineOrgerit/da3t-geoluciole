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

    static  let TITLE_BAR_PADDING_HORIZONTAL: CGFloat = 10

    // API URL
    static let API_URL = "http://datamuseum.univ-lr.fr:80/geolucioles/data/_bulk"
}
