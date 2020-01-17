//
//  CustomUILabel.swift
//  Geoluciole
//
//  Created by local192 on 13/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import UIKit
import Foundation

class CustomUILabel: UILabel {
    
    func setStyle (style: LabelStyle) {
        self.adjustsFontForContentSizeCategory = true
        
        switch style {
        case .TitreSectionBadges:
            self.font = UIFont.preferredFont(forTextStyle: .title2)
        case .SousTitreSection:
            self.font = UIFont.preferredFont(forTextStyle: .title3)
        case .Paragraphe:
            self.font = UIFont.preferredFont(forTextStyle: .body)
        }
    }
}