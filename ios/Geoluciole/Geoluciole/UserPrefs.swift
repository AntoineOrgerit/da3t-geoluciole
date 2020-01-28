//
//  UserPrefs.swift
//  Geoluciole
//
//  Created by Jessy Barritault on 10/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class UserPrefs {

    fileprivate static var INSTANCE: UserPrefs!
    fileprivate var userPrefs = UserDefaults.standard

    static let KEY_DUREE_ENGAGEMENT = "duree_engagement"
    static let KEY_TYPE_ENGAGEMENT = "type_engagement"
    static let KEY_SEND_DATA = "send_data"
    static let KEY_LANGUAGE = "language"
    static let KEY_LAST_POINT = "last_point"
    static let KEY_DISTANCE = "distance"
    static let KEY_IDENTIFIER = "identifier"
    static let KEY_RGPD_CONSENT = "rgpd_consent"
    static let KEY_FORMULAIRE_CONSENT = "formulaire_consent"
    static let KEY_DATE_START_ENGAGEMENT = "date_start_engagement"
    static let KEY_DATE_END_ENGAGEMENT = "date_end_engagement"
    static let KEY_FORMULAIRE_REMPLI = "formulaire_renseigne"

    
    fileprivate init() {
        self.userPrefs = UserDefaults.standard

        // si la durée d'engagement est renseigné
        if self.userPrefs.object(forKey: UserPrefs.KEY_DUREE_ENGAGEMENT) == nil {
            self.setPrefs(key: UserPrefs.KEY_DUREE_ENGAGEMENT, value: 1)
        }

        // si le type d'engagement est renseigné 0:heure 1:jour
        if self.userPrefs.object(forKey: UserPrefs.KEY_TYPE_ENGAGEMENT) == nil {
            self.setPrefs(key: UserPrefs.KEY_TYPE_ENGAGEMENT, value: 0)
        }

        // Par défaut, on active pas la collecte de données
        if self.userPrefs.object(forKey: UserPrefs.KEY_SEND_DATA) == nil {
            self.setPrefs(key: UserPrefs.KEY_SEND_DATA, value: false)
        }
        
        // Si la langue n'est pas définit, on prend la langue du système par défaut
        if self.userPrefs.object(forKey: UserPrefs.KEY_LANGUAGE) == nil {
            // on récupère la langue du système
            let languageCode = Locale.current.regionCode?.lowercased()
            
            var language = ""
            
            if languageCode != nil {
                // Si le français est défini, on le prend
                if languageCode == "fr" {
                    language = Constantes.LANGUAGE_FRENCH
                // Sinon on met anglais par défaut
                } else {
                    language = Constantes.LANGUAGE_ENGLISH
                }
            }
            self.setPrefs(key: UserPrefs.KEY_LANGUAGE, value: language)
        }
        
        if self.userPrefs.object(forKey: UserPrefs.KEY_FORMULAIRE_REMPLI) == nil {
            self.setPrefs(key: UserPrefs.KEY_FORMULAIRE_REMPLI, value: false)
        }
    }

    static func getInstance() -> UserPrefs {
        if INSTANCE == nil {
            INSTANCE = UserPrefs()
        }
        return INSTANCE
    }

    func setPrefs(key: String, value: Any) {
        self.userPrefs.set(value, forKey: key)
        self.userPrefs.synchronize()
    }

    func bool(forKey key: String, defaultValue: Bool = false) -> Bool {
        if self.userPrefs.object(forKey: key) != nil {
            return self.userPrefs.bool(forKey: key)
        }
        return defaultValue
    }

    func string(forKey key: String, defaultValue: String = "") -> String {
        if self.userPrefs.object(forKey: key) != nil {
            return self.userPrefs.string(forKey: key)!
        }
        return defaultValue
    }

    func int(forKey key: String, defaultValue: Int = 0) -> Int {
        if self.userPrefs.object(forKey: key) != nil {
            return self.userPrefs.integer(forKey: key)
        }
        return defaultValue
    }

    func object(forKey key: String) -> Any? {
        return self.userPrefs.object(forKey: key)
    }
}
