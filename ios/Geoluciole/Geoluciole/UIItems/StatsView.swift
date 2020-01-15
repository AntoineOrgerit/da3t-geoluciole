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
        lbDistance.setStyle(style: .Paragraphe)
        lbDistance.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lbDistance)

        let wrapData = UIView()
        wrapData.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapData)
        
        let lbValeurDist = CustomUILabel()
        lbValeurDist.text = "0"
        lbValeurDist.setStyle(style: .Paragraphe)
        lbValeurDist.translatesAutoresizingMaskIntoConstraints = false
        wrapData.addSubview(lbValeurDist)

        let lbvaleurMetrique = CustomUILabel()
        lbvaleurMetrique.text = "Km"
        lbvaleurMetrique.setStyle(style: .Paragraphe)
        lbvaleurMetrique.translatesAutoresizingMaskIntoConstraints = false
        wrapData.addSubview(lbvaleurMetrique)

        NSLayoutConstraint.activate([
            
            self.bottomAnchor.constraint(equalTo: wrapData.bottomAnchor),
            
            lbTitle.topAnchor.constraint(equalTo: self.topAnchor),
            lbTitle.leftAnchor.constraint(equalTo: self.leftAnchor),
            lbTitle.rightAnchor.constraint(equalTo: self.rightAnchor),
            lbTitle.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            lbDistance.topAnchor.constraint(equalTo: lbTitle.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            lbDistance.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            lbDistance.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            
            wrapData.topAnchor.constraint(equalTo: lbTitle.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            wrapData.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            wrapData.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            wrapData.leftAnchor.constraint(equalTo: lbDistance.rightAnchor),
            wrapData.bottomAnchor.constraint(equalTo: lbValeurDist.bottomAnchor),
            
            lbValeurDist.topAnchor.constraint(equalTo: wrapData.topAnchor),
            lbValeurDist.leftAnchor.constraint(equalTo: wrapData.leftAnchor),
            
            lbvaleurMetrique.topAnchor.constraint(equalTo: wrapData.topAnchor),
            lbvaleurMetrique.leftAnchor.constraint(equalTo: lbValeurDist.rightAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            lbvaleurMetrique.bottomAnchor.constraint(equalTo: wrapData.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
