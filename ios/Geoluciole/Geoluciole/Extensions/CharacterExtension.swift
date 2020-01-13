//
// Created by Alexandre BARET on 13/01/2020.
// Copyright (c) 2020 Université La Rochelle. All rights reserved.
//

import Foundation

extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
}