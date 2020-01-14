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

    fileprivate let trophy = CustomUIImageView(frame: .zero)
    fileprivate let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = "Badge récemment obtenu"
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
            trophy.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            trophy.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func setImage(nom: String){
        self.trophy.image = UIImage(named: nom)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
