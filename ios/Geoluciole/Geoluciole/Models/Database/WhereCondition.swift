//
//  WhereCondition.swift
//  Geoluciole
//
//  Created by local192 on 09/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class WhereCondition {

    var column: String!
    var condition: String!

    init(onColumn: String, withCondition: String) {
        self.column = onColumn
        self.condition = withCondition
    }

    func toString() -> String {
        return self.column + " " + self.condition
    }
}
