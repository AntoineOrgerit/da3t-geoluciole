//
//  Params.swift
//  Geoluciole
//
//  Created by Jessy Barritault on 10/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class Params {
    
    fileprivate static var INSTANCE: Params!
    var param: UserDefaults

    fileprivate init() {
        self.param = UserDefaults.standard
        // si la durée d'engagement est renseigné
        if !self.param.bool(forKey: "duree_engagement") {
            self.param.set(1, forKey: "duree_engagement")
        }
        // si le type d'engagement est renseigné 0:heure 1:jour
        if !self.param.bool(forKey: "type_engagement"){
            self.param.set(0, forKey: "type_engagement")
        }
        // si la langue est renseigné 0:fr 1:eng
        if !self.param.bool(forKey: "langue"){
            self.param.set(0, forKey: "langue")
        }
        self.param.synchronize()
    }

    static func getInstance() -> Params {
        if INSTANCE == nil {
            INSTANCE = Params()
        }
        return INSTANCE
    }
}
