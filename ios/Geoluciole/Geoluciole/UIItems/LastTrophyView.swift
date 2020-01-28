//
//  LastTrophyView.swift
//  Geoluciole
//
//  Created by Thibaud Lambert on 13/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class LastTrophyView: UIView {

    fileprivate var trophy: CustomUIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        let label = CustomUILabel()
        label.setStyle(style: .subtitleBold)
        label.text = Tools.getTranslate(key: "last_achievement_obtained")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        self.trophy = CustomUIImageView(frame: .zero)
        self.trophy.image = UIImage(named: "no-badge")
        self.trophy.translatesAutoresizingMaskIntoConstraints = false
        self.trophy.contentMode = .scaleAspectFit
        self.addSubview(self.trophy)

        NSLayoutConstraint.activate([
            
            label.widthAnchor.constraint(equalTo: self.widthAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor),
            label.rightAnchor.constraint(equalTo: self.rightAnchor),
            label.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.trophy.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.trophy.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            self.trophy.heightAnchor.constraint(equalTo: self.trophy.widthAnchor),
            self.trophy.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            self.bottomAnchor.constraint(equalTo: self.trophy.bottomAnchor)
        ])
    }

    func setImage(nom: String) {
        self.trophy.image = UIImage(named: nom) ?? UIImage(named: "no-img")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
