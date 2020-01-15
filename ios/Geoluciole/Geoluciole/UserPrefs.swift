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
    static let KEY_LAST_POINT = "last_point"
    static let DISTANCE = "distance"

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

        if self.userPrefs.object(forKey: UserPrefs.KEY_SEND_DATA) == nil {
            self.setPrefs(key: UserPrefs.KEY_SEND_DATA, value: true)
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
