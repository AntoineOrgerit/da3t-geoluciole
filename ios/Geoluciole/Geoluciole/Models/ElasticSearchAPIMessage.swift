//
// Created by Alexandre BARET on 10/01/2020.
// Copyright (c) 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class ElasticSearchAPIMessage: Codable {
    
    let uuid: String
    let locations: [Location]

    init(uuid: String, locations: [Location]) {
        self.uuid = uuid
        self.locations = locations
    }
}
