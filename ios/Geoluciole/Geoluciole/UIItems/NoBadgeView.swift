//
//  NoBadgeView.swift
//  Geoluciole
//
//  Created by Thibaud LAMBERT on 15/01/2020.
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
        img.contentMode = .scaleAspectFit
        self.addSubview(img)
        
        let label = CustomUILabel()
        label.text = Tools.getTranslate(key: "no_achievement_picture_description")
        label.setStyle(style: .bodyRegular)
        label.textAlignment = .center
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
            label.topAnchor.constraint(equalTo: img.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
