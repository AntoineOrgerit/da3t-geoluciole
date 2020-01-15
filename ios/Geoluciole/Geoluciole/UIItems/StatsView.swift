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
    var uniteMetrique = CustomUILabel()
    let lbTitle = CustomUILabel()
    let lbDistance = CustomUILabel()
    let wrapData = UIView()
    var lbValeurDist = CustomUILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false

        lbTitle.text = "Statistiques"
        lbTitle.setStyle(style: .TitreSectionBadges)
        lbTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lbTitle)

        lbDistance.text = "Distance parcourue"
        lbDistance.setStyle(style: .Paragraphe)
        lbDistance.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lbDistance)

        wrapData.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapData)

        
        setValeurDist()
        lbValeurDist.setStyle(style: .Paragraphe)
        lbValeurDist.translatesAutoresizingMaskIntoConstraints = false
        wrapData.addSubview(lbValeurDist)

        uniteMetrique.text = "Km"
        uniteMetrique.setStyle(style: .Paragraphe)
        uniteMetrique.translatesAutoresizingMaskIntoConstraints = false
        wrapData.addSubview(uniteMetrique)

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

            uniteMetrique.topAnchor.constraint(equalTo: wrapData.topAnchor),
            uniteMetrique.leftAnchor.constraint(equalTo: lbValeurDist.rightAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            uniteMetrique.bottomAnchor.constraint(equalTo: wrapData.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setValeurDist() {
        var valeur_dist = Tools.getdist_Stat()
        if valeur_dist < 1000 {
            uniteMetrique.text = "m"
        } else {
            valeur_dist = Tools.roundDist(valeur_dist / 1000 , places: 2)
            uniteMetrique.text = "Km"
        }
        
        lbValeurDist.text = String(valeur_dist)
    }
}
