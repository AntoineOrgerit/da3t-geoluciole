//
// Created by Alexandre BARET on 13/01/2020.
// Copyright (c) 2020 Université La Rochelle. All rights reserved.
//

import Foundation

extension String {
    var asciiArray: [UInt32] {
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }

    // Source fonction de hashage : https://stackoverflow.com/a/44413863
    func hashCode() -> Int32 {
        var h: Int32 = 0
        for i in self.asciiArray {
            h = 31 &* h &+ Int32(i)
        }

        return h
    }
}