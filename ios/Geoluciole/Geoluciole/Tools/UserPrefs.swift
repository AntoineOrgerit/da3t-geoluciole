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

class UserPrefs {

    fileprivate static var INSTANCE: UserPrefs!
    fileprivate var userPrefs = UserDefaults.standard

    static let KEY_DUREE_ENGAGEMENT = "duree_engagement"
    static let KEY_TYPE_ENGAGEMENT = "type_engagement"
    static let KEY_SEND_DATA = "send_data"
    static let KEY_LAST_POINT = "last_point"
    static let KEY_DISTANCE_TRAVELED = "distance"
    static let KEY_IDENTIFIER = "identifier"
    static let KEY_RGPD_CONSENT = "rgpd_consent"
    static let KEY_FORMULAIRE_CONSENT = "formulaire_consent"
    static let KEY_DATE_START_ENGAGEMENT = "date_start_engagement"
    static let KEY_DATE_END_ENGAGEMENT = "date_end_engagement"
    static let APPLE_LANGUAGE_KEY = "AppleLanguages"
    static let KEY_LAST_BADGE = "last_badge"
    static let KEY_FORMULAIRE_REMPLI = "formulaire_accepte"
    static let KEY_GPS_CONSENT_DATA = "data_gps_consent"
    static let KEY_FORMULAIRE_CONSENT_DATA = "data_form_consent"
    static let KEY_DATE_START_STAY = "date_debut_sejour"
    static let KEY_DATE_END_STAY = "date_fin_sejour"
    
    fileprivate init() {

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
        if self.userPrefs.object(forKey: UserPrefs.APPLE_LANGUAGE_KEY) == nil {
            // on récupère la langue du système
            let languageCode = Locale.current.regionCode?.lowercased()

            var language = ""

            if languageCode != nil {
                // Si le français est défini, on le prend
                if languageCode == "fr" {
                    language = Tools.getTranslate(key: "french_language")
                // Sinon on met anglais par défaut
                } else {
                    language = Tools.getTranslate(key: "english_language")
                }
            }
            self.setPrefs(key: UserPrefs.APPLE_LANGUAGE_KEY, value: language)
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
    
    func removePrefs(key: String) {
        self.userPrefs.removeObject(forKey: key)
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
    
    func double(forKey key: String, defaultValue: Double = 0) -> Double {
        if self.userPrefs.object(forKey: key) != nil {
            return self.userPrefs.double(forKey: key)
        }
        return defaultValue
    }
}
