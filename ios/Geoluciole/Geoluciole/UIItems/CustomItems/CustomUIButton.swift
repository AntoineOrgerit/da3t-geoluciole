//
//  CustomUIButton.swift
//  Geoluciole
//
//  Created by Alexandre BARET on 13/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class CustomUIButton: UIButton {

    var onClick: ((CustomUIButton) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18)
        self.addTarget(self, action: #selector(CustomUIButton.touchOnUIButton), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /// Applique le style définition en paramètre (énumération)
    func setStyle(style: ButtonStyle) {

        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        self.titleLabel?.adjustsFontForContentSizeCategory = true

        switch style {
        case .settingLight:
            self.backgroundColor = .white
            self.layer.borderColor = UIColor.settingsButtonDark.cgColor
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 5
            self.setTitleColor(.settingsButtonDark, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        case .settingDark:
            self.backgroundColor = .settingsButtonDark
            self.layer.borderColor = UIColor.settingsButtonDark.cgColor
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 5
            self.setTitleColor(.settingsButtonLight, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        case .disabled:
            self.backgroundColor = .disabledButton
            self.layer.borderColor = UIColor.disabledButton.cgColor
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 5
            self.setTitleColor(.white, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        case .active:
            self.backgroundColor = .activeButton
            self.layer.borderColor = UIColor.activeButton.cgColor
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 5
            self.setTitleColor(.white, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        case .delete:
            self.backgroundColor = .delete
            self.layer.borderColor = UIColor.delete.cgColor
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 5
            self.setTitleColor(.white, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        case .defaultStyle:
            self.backgroundColor = .white
            self.layer.borderColor = UIColor.settingsButtonDark.cgColor
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 5
            self.setTitleColor(.settingsButtonDark, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }

    @objc fileprivate func touchOnUIButton() {
        self.onClick?(self)
    }
}
