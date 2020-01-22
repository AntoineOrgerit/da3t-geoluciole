//
//  LastTrophyView.swift
//  Geoluciole
//
//  Created by local192 on 13/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class LastTrophyView: UIView {

    fileprivate var trophy: CustomUIImageView!
    fileprivate var label: CustomUILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        let label = CustomUILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = Tools.getTranslate(key: "last_achievement_obtained")
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        let trophy = CustomUIImageView(frame: .zero)
        trophy.image = UIImage(named: "no-badge")
        trophy.translatesAutoresizingMaskIntoConstraints = false
        trophy.contentMode = .scaleAspectFit
        self.addSubview(trophy)

        NSLayoutConstraint.activate([
            
            label.widthAnchor.constraint(equalTo: self.widthAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor),
            label.rightAnchor.constraint(equalTo: self.rightAnchor),
            label.topAnchor.constraint(equalTo: self.topAnchor),
            
            trophy.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            trophy.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            trophy.heightAnchor.constraint(equalTo: trophy.widthAnchor),
            trophy.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            self.bottomAnchor.constraint(equalTo: trophy.bottomAnchor)
            
        ])
    }

    func setImage(nom: String) {
        self.trophy.image = UIImage(named: nom)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
