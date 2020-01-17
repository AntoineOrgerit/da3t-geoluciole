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

    fileprivate var uniteMetrique: CustomUILabel!
    fileprivate var lbTitle: CustomUILabel!
    fileprivate var lbDistance: CustomUILabel!
    fileprivate var wrapData: UIView!
    fileprivate var lbValeurDist: CustomUILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

//        self.translatesAutoresizingMaskIntoConstraints = false

        self.lbTitle = CustomUILabel()
        self.lbTitle.text = "Statistiques"
        self.lbTitle.font = UIFont.preferredFont(forTextStyle: .title2)
        self.lbTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.lbTitle)

        self.lbDistance = CustomUILabel()
        self.lbDistance.text = "Distance parcourue"
        self.lbDistance.font = UIFont.preferredFont(forTextStyle: .body)
        self.lbDistance.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.lbDistance)

        self.wrapData = UIView()
        self.wrapData.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.wrapData)

        self.lbValeurDist = CustomUILabel()
        self.lbValeurDist.text = "0"
        self.lbValeurDist.font = UIFont.preferredFont(forTextStyle: .body)
        self.lbValeurDist.translatesAutoresizingMaskIntoConstraints = false
        self.wrapData.addSubview(self.lbValeurDist)

        self.uniteMetrique = CustomUILabel()
        self.uniteMetrique.text = "Km"
        self.uniteMetrique.setStyle(style: .Paragraphe)
        self.uniteMetrique.translatesAutoresizingMaskIntoConstraints = false
        self.wrapData.addSubview(self.uniteMetrique)
        
        self.setValeurDist()

        NSLayoutConstraint.activate([

            self.bottomAnchor.constraint(equalTo: self.wrapData.bottomAnchor),

            self.lbTitle.topAnchor.constraint(equalTo: self.topAnchor),
            self.lbTitle.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.lbTitle.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.lbTitle.widthAnchor.constraint(equalTo: self.widthAnchor),

            self.lbDistance.topAnchor.constraint(equalTo: self.lbTitle.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.lbDistance.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            self.lbDistance.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),

            self.wrapData.topAnchor.constraint(equalTo: self.lbTitle.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.wrapData.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            self.wrapData.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            self.wrapData.leftAnchor.constraint(equalTo: self.lbDistance.rightAnchor),
            self.wrapData.bottomAnchor.constraint(equalTo: self.lbValeurDist.bottomAnchor),

            self.lbValeurDist.topAnchor.constraint(equalTo: self.wrapData.topAnchor),
            self.lbValeurDist.leftAnchor.constraint(equalTo: self.wrapData.leftAnchor),

            self.uniteMetrique.topAnchor.constraint(equalTo: self.wrapData.topAnchor),
            self.uniteMetrique.leftAnchor.constraint(equalTo: self.lbValeurDist.rightAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            self.uniteMetrique.bottomAnchor.constraint(equalTo: self.wrapData.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setValeurDist() {
        var valeurDist = Tools.getDistStat()
        
        if valeurDist < 1000 {
            self.uniteMetrique.text = "m"
        } else {
            valeurDist = Tools.roundDist(valeurDist / 1000, places: 2)
            self.uniteMetrique.text = "Km"
        }

        self.lbValeurDist.text = String(valeurDist)
    }
}