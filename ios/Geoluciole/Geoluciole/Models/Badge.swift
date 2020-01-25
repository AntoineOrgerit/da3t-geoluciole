//
//  Badge.swift
//  Geoluciole
//
//  Created by Thibaud LAMBERT on 21/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class Badge {

    var id: Int
    var type: String
    var name: String
    var description: String
    var latitude: Double?
    var longitude: Double?
    var proximity: Int?
    var distance: Double?
    var resource: String
    var isObtain: Bool

    init(_ dictionnary: [String: Any]) {
        self.id = dictionnary["id"] as! Int
        self.type = dictionnary["type"] as! String
        self.name = dictionnary["name"] as! String
        self.description = Tools.getTranslate(key: dictionnary["description"] as! String)
        self.latitude = dictionnary["latitude"] as? Double ?? nil
        self.longitude = dictionnary["longitude"] as? Double ?? nil
        self.proximity = dictionnary["proximity"] as? Int ?? nil
        self.distance = dictionnary["distance"] as? Double ?? nil
        self.resource = dictionnary["resource"] as! String
        self.isObtain = dictionnary["is_obtain"] as? Bool ?? false
    }
}
