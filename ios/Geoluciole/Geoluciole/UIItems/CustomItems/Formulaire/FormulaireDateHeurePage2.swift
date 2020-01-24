//
//  FormulaireDateHeurePage2.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 23/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FormulaireDateHeurePage2: UIView {


    var zoneDateArrivee: UIView!
    var zoneDateDepart: UIView!

    init() {
        super.init(frame: .zero)

        self.zoneDateDepart = UIView(frame: .zero)
        self.zoneDateDepart.translatesAutoresizingMaskIntoConstraints = false
        self.zoneDateArrivee = UIView(frame: .zero)
        self.zoneDateArrivee.translatesAutoresizingMaskIntoConstraints = false

        let jourArrivee = FormZoneDate(title: "Date et heure d'arrivée à La Rochelle", labelBton: "CHOISIR UNE DATE")
        jourArrivee.translatesAutoresizingMaskIntoConstraints = false
        let heureArrivee = FormZoneDate(title: "", labelBton: "CHOISIR UNE HEURE")
        heureArrivee.translatesAutoresizingMaskIntoConstraints = false
        self.zoneDateArrivee.addSubview(jourArrivee)
        self.zoneDateArrivee.addSubview(heureArrivee)

        let jourDepart = FormZoneDate(title: "Date et heure de départ de La Rochelle", labelBton: "CHOISIR UNE DATE")
        jourDepart.translatesAutoresizingMaskIntoConstraints = false
        let heureDepart = FormZoneDate(title: "", labelBton: "CHOISIR UNE HEURE")
        heureDepart.translatesAutoresizingMaskIntoConstraints = false
        self.zoneDateDepart.addSubview(jourDepart)
        self.zoneDateDepart.addSubview(heureDepart)

        self.addSubview(zoneDateDepart)
        self.addSubview(zoneDateArrivee)
        //zoneDateArrivee
        NSLayoutConstraint.activate([
            jourArrivee.topAnchor.constraint(equalTo: zoneDateArrivee.topAnchor),
            jourArrivee.leftAnchor.constraint(equalTo: zoneDateArrivee.leftAnchor),
            jourArrivee.rightAnchor.constraint(equalTo: zoneDateArrivee.rightAnchor),

            //heureArrivee
            heureArrivee.topAnchor.constraint(equalTo: jourArrivee.bottomAnchor),
            heureArrivee.leftAnchor.constraint(equalTo: zoneDateArrivee.leftAnchor),
            heureArrivee.rightAnchor.constraint(equalTo: zoneDateArrivee.rightAnchor),

            zoneDateArrivee.bottomAnchor.constraint(equalTo: heureArrivee.bottomAnchor)
        ])
        //zoneDateDepart
        NSLayoutConstraint.activate([
            jourDepart.topAnchor.constraint(equalTo: zoneDateDepart.topAnchor),
            jourDepart.leftAnchor.constraint(equalTo: zoneDateDepart.leftAnchor),
            jourDepart.rightAnchor.constraint(equalTo: zoneDateDepart.rightAnchor),

            //heureArrivee
            heureDepart.topAnchor.constraint(equalTo: jourDepart.bottomAnchor),
            heureDepart.leftAnchor.constraint(equalTo: zoneDateDepart.leftAnchor),
            heureDepart.rightAnchor.constraint(equalTo: zoneDateDepart.rightAnchor),

            zoneDateDepart.bottomAnchor.constraint(equalTo: heureDepart.bottomAnchor)
        ])

        //self
        NSLayoutConstraint.activate([

            zoneDateArrivee.topAnchor.constraint(equalTo: self.topAnchor),
            zoneDateArrivee.leftAnchor.constraint(equalTo: self.leftAnchor),
            zoneDateArrivee.rightAnchor.constraint(equalTo: self.rightAnchor),

            //heureArrivee
            zoneDateDepart.topAnchor.constraint(equalTo: zoneDateArrivee.bottomAnchor),
            zoneDateDepart.leftAnchor.constraint(equalTo: self.leftAnchor),
            zoneDateDepart.rightAnchor.constraint(equalTo: self.rightAnchor),

            self.bottomAnchor.constraint(equalTo: zoneDateDepart.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
