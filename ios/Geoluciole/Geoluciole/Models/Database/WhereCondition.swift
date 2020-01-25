//
//  WhereCondition.swift
//  Geoluciole
//
//  Created by Thibaud LAMBERT on 09/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class WhereCondition {

    var column: String!
    var value: Any!

    init(onColumn: String, withCondition: Any) {
        self.column = onColumn
        self.value = withCondition
    }
}
