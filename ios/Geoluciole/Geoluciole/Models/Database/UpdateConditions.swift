//
//  UpdateConditions.swift
//  Geoluciole
//
//  Created by local192 on 21/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class UpdateConditions {
    
    var column: String!
    var value: Any!

    init(onColumn: String, newValue: Any) {
        self.column = onColumn
        self.value = newValue
    }
}
