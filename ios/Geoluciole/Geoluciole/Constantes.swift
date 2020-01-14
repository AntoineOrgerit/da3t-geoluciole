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
    static let TEXTE_TITLE_RGPD = "Consentement RGPD"
    static let TEXTE_SOUS_TITLE_RGPD = "PROJET Région Nouvelle-Aquitaine DA3T"
    static let TEXTE_RGPD = "Les données recueillies par l’application font l’objet d’une inscription sur le registre des traitements de la Rochelle Université. Les données sont recueillies à des fins de recherche par les chercheurs du LIENSS dans le cadre du projet DA3T.\n Le projet de recherche vise à proposer un dispositif d’analyse des traces géonumériques dans le but d’améliorer la gestion et la valorisation des territoires touristiques en Nouvelle-Aquitaine. \n La finalité de l’étude est d’interroger l’apport supposé des traces géonumériques dans la compréhension de la ville touristique atlantique. \n Les données recueillies par l’application font l’objet d’une inscription sur le registre des traitements de la Rochelle Université. \n\n Les données sont recueillies à des fins de recherche par les chercheurs du LIENSS dans le cadre du projet DA3T. \n\n Le projet de recherche vise à proposer un dispositif d’analyse des traces géonumériques dans le but d’améliorer la gestion et la valorisation des territoires touristiques en Nouvelle-Aquitaine. \n\n La finalité de l’étude est d’interroger l’apport supposé des traces géonumériques dans la compréhension de la ville touristique atlantique."
    static let TEXTE_VALIDATION_DROIT = "J’autorise les chercheurs du laboratoire LIENSS à utiliser mes données dans le cadre du projet DA3T"

    // SERVEUR ELASTIC SEARCH

    static let API_URL_UNIV_LR = "http://datamuseum.univ-lr.fr:80/geolucioles/data/_bulk"
    static let API_URL_SERVER_TEST = "http://86.233.189.163:9200/geolucioles/data/_bulk"
    static let TIMER_SEND_DATA = 60.0 * 2 // en s ==> paramètre pour l'envoi régulier au serveur
}
