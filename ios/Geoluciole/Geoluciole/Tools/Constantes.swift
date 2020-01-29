//    Copyright (c) 2020, La Rochelle Université
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
import CoreLocation

class Constantes {

    // Mettre a TRUE si on veut afficher les logs
    static let DEBUG = true

    static let DB_NAME = "geoluciole.sqlite"
    static let CGU_NAME = "cgu.pdf"
    static let BADGES_FILENAME = "badges.json"

    static let REVOQ_CONSENT_MAIL = "melanie.mondo1@univ-lr.fr"
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
    
    // REGEX
    static let REGEX_PHONE = "([+]{0,1})([0-9]{1,15})$"
    static let REGEX_MAIL = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
}
