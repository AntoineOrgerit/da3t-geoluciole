//
//  CustomUIButton.swift
//  Geoluciole
//
//  Created by Alexandre BARET on 13/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import UIKit

class CustomUIButton: UIButton {
    
    var onClick: ((CustomUIButton) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(CustomUIButton.touchOnUIButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /// Applique le style définition en paramètre (énumération)
    func setStyle(color: ButtonStyle) {
        var bgColor: UIColor

        switch color {
        case .buttonLight:
            bgColor = UIColor(red: 255 / 255, green: 220 / 255, blue: 0 / 255, alpha: 1.0)
        case .buttonLightDark:
            bgColor = UIColor(red: 250 / 255, green: 188 / 255, blue: 60 / 255, alpha: 1.0)
        case .buttonPrimaryDark:
            bgColor = UIColor(red: 241 / 255, green: 145 / 255, blue: 67 / 255, alpha: 1.0)
        case .buttonDark:
            bgColor = UIColor(red: 235 / 255, green: 108 / 255, blue: 50 / 255, alpha: 1.0)
        default:
            bgColor = UIColor(red: 255 / 255, green: 178 / 255, blue: 56 / 255, alpha: 1.0)
        }
        
        // On applique le style au background
        layer.backgroundColor = bgColor.cgColor
        layer.cornerRadius = 5 // bords arrondis de 5px
    }
    
    @objc fileprivate func touchOnUIButton() {
        self.onClick?(self)
    }

}
