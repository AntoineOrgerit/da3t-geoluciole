//
//  CustomUILabel.swift
//  Geoluciole
//
//  Created by Laurent RAYEZ on 13/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import UIKit
import Foundation

class CustomUILabel: UILabel {

    func setStyle (style: LabelStyle) {
        
        switch style {

        case .titleRegular:
            self.font = UIFont(name: "Roboto-Regular", size: 24)
        case .subtitleRegular:
            self.font = UIFont(name: "Roboto-Regular", size: 20)
        case .bodyRegular:
            self.font = UIFont(name: "Roboto-Regular", size: 16)
        case .titleItalic:
            self.font = UIFont(name: "Roboto-Italic", size: 24)
        case .subtitleItalic:
            self.font = UIFont(name: "Roboto-Italic", size: 20)
        case .bodyItalic:
            self.font = UIFont(name: "Roboto-Italic", size: 16)
        case .titleBold:
            self.font = UIFont(name: "Roboto-Bold", size: 24)
        case .subtitleBold:
            self.font = UIFont(name: "Roboto-Bold", size: 20)
        case .bodyBold:
            self.font = UIFont(name: "Roboto-Bold", size: 16)
        }
    }
}
