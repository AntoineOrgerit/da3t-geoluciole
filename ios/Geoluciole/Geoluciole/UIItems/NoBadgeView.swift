//
//  NoBadgeView.swift
//  Geoluciole
//
//  Created by local192 on 15/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class NoBadgeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "no-badge")
        self.addSubview(img)
        
        let label = UILabel()
        label.text = "Aucun badge"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            img.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            img.heightAnchor.constraint(equalTo: img.widthAnchor),
            img.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            img.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            label.widthAnchor.constraint(equalTo: img.widthAnchor),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.topAnchor.constraint(equalTo: img.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
