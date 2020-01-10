//
//  Params.swift
//  Geoluciole
//
//  Created by Jessy Barritault on 10/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class Params{
    fileprivate static var INSTANCE: Params!
    var param : UserDefaults
    
    fileprivate init(){
        self.param = UserDefaults.standard
        // si donnée d'envoi deja stocké
        if self.param.bool(forKey: "send_data") {
            self.param.set(self.param.bool(forKey: "send_data"), forKey: "send_data")
        } else {
            self.param.set(true, forKey: "send_data")
        }
        // si la durée d'engagement est renseigné
        if self.param.integer(forKey: "duree_engagement") != nil {
            self.param.set(self.param.integer(forKey: "duree_engagement"), forKey: "duree_engagement")
        } else {
            self.param.set(1, forKey: "duree_engagement")
        }
        // si le type d'engagement est renseigné 0:heure 1:jour
        if self.param.integer(forKey: "type_engagement") != nil {
            self.param.set(self.param.integer(forKey: "type_engagement"), forKey: "type_engagement")
        } else {
            self.param.set(0, forKey: "type_engagement")
        }
        // si la langue est renseigné 0:fr 1:eng
        if self.param.integer(forKey: "langue") != nil {
            self.param.set(self.param.integer(forKey: "langue"), forKey: "langue")
        } else {
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
