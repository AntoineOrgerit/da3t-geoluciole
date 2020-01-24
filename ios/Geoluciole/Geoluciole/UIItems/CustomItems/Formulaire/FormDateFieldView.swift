//
//  FormDateFieldView.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 23/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FormDateFieldView: UIView {
    
    var titre: CustomUILabel!
    var zoneDatesDeb: FormZoneDate!
    var zoneDatesFin: FormZoneDate!
    
    init(titre: String) {
        super.init(frame: .zero)
        self.titre = CustomUILabel()
        self.titre.translatesAutoresizingMaskIntoConstraints = false
        self.titre.setStyleLabel(style: .SousTitreSection)
        self.titre.text = titre
        
        self.zoneDatesDeb = FormZoneDate(title: "Début de la collecte", labelBton: "CHOISIR UNE DATE")
        self.zoneDatesDeb.translatesAutoresizingMaskIntoConstraints = false
        self.zoneDatesDeb.setDate(plus: 0)
        
        self.zoneDatesFin = FormZoneDate(title: "Fin de la collecte", labelBton: "CHOISIR UNE DATE")
        self.zoneDatesFin.translatesAutoresizingMaskIntoConstraints = false
        self.zoneDatesFin.setDate(plus: 1)
        
        self.addSubview(self.titre)
        self.addSubview(self.zoneDatesDeb)
        self.addSubview(self.zoneDatesFin)
        
        NSLayoutConstraint.activate([
            self.titre.topAnchor.constraint(equalTo: self.topAnchor),
            self.titre.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.titre.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            self.zoneDatesDeb.topAnchor.constraint(equalTo: self.titre.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.zoneDatesDeb.leftAnchor.constraint(equalTo: self.titre.leftAnchor),
            self.zoneDatesDeb.rightAnchor.constraint(equalTo: self.titre.rightAnchor),
            
            self.zoneDatesFin.topAnchor.constraint(equalTo: self.zoneDatesDeb.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.zoneDatesFin.leftAnchor.constraint(equalTo: self.titre.leftAnchor),
            self.zoneDatesFin.rightAnchor.constraint(equalTo: self.titre.rightAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
