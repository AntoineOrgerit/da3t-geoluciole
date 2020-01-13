//
//  StatsView.swift
//  Geoluciole
//
//  Created by local192 on 13/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class StatsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let lbTitle = CustomUILabel()
        lbTitle.text = "Statistiques"
        lbTitle.setStyle(style: .TitreSectionBadges)
        lbTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lbTitle)

        let lbDistance = CustomUILabel()
        lbDistance.text = "Distance parcourue"
        lbDistance.setStyle(style: .paragraphe)
        lbDistance.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lbDistance)

        let lbValeurDist = CustomUILabel()
        lbValeurDist.text = "0"
        lbValeurDist.setStyle(style: .paragraphe)
        lbValeurDist.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lbValeurDist)

        let lbvaleurMetrique = CustomUILabel()
        lbvaleurMetrique.text = "Km"
        lbvaleurMetrique.setStyle(style: .paragraphe)
        lbvaleurMetrique.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lbvaleurMetrique)

        

        NSLayoutConstraint.activate([
            lbTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            lbTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            lbDistance.topAnchor.constraint(equalTo: lbTitle.bottomAnchor, constant: 50),
            lbDistance.leadingAnchor.constraint(equalTo: lbTitle.leadingAnchor, constant: 50),
            lbValeurDist.topAnchor.constraint(equalTo: lbDistance.topAnchor),
            lbValeurDist.leadingAnchor.constraint(equalTo: lbDistance.trailingAnchor, constant: 50),
            lbvaleurMetrique.topAnchor.constraint(equalTo: lbDistance.topAnchor),
            lbvaleurMetrique.leadingAnchor.constraint(equalTo: lbValeurDist.trailingAnchor, constant: 50)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
