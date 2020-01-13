//
//  CustomUILabel.swift
//  Geoluciole
//
//  Created by local192 on 13/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import UIKit
import Foundation


enum LabelStyle {
    case TitreSectionBadges
    case SousTitreSection
    case paragraphe
}

class CustomUILabel: UILabel {

    func setStyle (style: LabelStyle) {
        switch style {
        case .TitreSectionBadges:
            self.font = UIFont.preferredFont(forTextStyle: .title2)
            self.adjustsFontForContentSizeCategory = true

            self.textAlignment = .left
        case .SousTitreSection:
            self.font = UIFont.preferredFont(forTextStyle: .title3)
            self.adjustsFontForContentSizeCategory = true

            self.textAlignment = .left
        case .paragraphe:
            self.font = UIFont.preferredFont(forTextStyle: .body)
            self.adjustsFontForContentSizeCategory = true

            self.textAlignment = .left
       
        }
    }
}
