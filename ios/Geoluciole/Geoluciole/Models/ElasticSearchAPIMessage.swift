//
// Created by Alexandre BARET on 10/01/2020.
// Copyright (c) 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class ElasticSearchAPIMessage: Codable {
    
    let identifier: String
    let locations: [Location]

    init(identifier: String, locations: [Location]) {
        self.identifier = identifier
        self.locations = locations
    }
}
