//
//  FormDate.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 23/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FormZoneDate: UIView {

    var titre: CustomUILabel!
    var container: UIView!
    var dateTxtFld: UITextField!

    init(title: String, labelBton: String) {
        super.init(frame: .zero)

        self.container = UIView()
        self.container.translatesAutoresizingMaskIntoConstraints = false

        self.titre = CustomUILabel()
        self.titre.setStyleLabel(style: .SousTitreSection)
        self.titre.text = title
        self.titre.numberOfLines = 0
        self.titre.translatesAutoresizingMaskIntoConstraints = false


        self.dateTxtFld = UITextField(frame: .zero)
        //self.dateTxtFld.text = getDateSystem()
        self.dateTxtFld.translatesAutoresizingMaskIntoConstraints = false

        let trait = UIView()
        trait.backgroundColor = .black
        trait.translatesAutoresizingMaskIntoConstraints = false

        let dateButton = CustomUIButton()
        dateButton.setTitle(labelBton, for: .normal)
        dateButton.setStyle(style: .active)
        dateButton.translatesAutoresizingMaskIntoConstraints = false

        self.container.addSubview(dateTxtFld)
        self.container.addSubview(trait)
        self.container.addSubview(dateButton)

        self.addSubview(self.titre)
        self.addSubview(self.container)

        //contraintes à l'intérieur du container
        NSLayoutConstraint.activate([
            self.dateTxtFld.topAnchor.constraint(equalTo: container.topAnchor),
            self.dateTxtFld.leftAnchor.constraint(equalTo: container.leftAnchor),
            self.dateTxtFld.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.45),

            trait.heightAnchor.constraint(equalToConstant: 1),
            trait.leftAnchor.constraint(equalTo: dateTxtFld.leftAnchor),
            trait.topAnchor.constraint(equalTo: dateTxtFld.bottomAnchor, constant: 5),
            trait.widthAnchor.constraint(equalTo: dateTxtFld.widthAnchor),

            dateButton.bottomAnchor.constraint(equalTo: trait.bottomAnchor),
            dateButton.rightAnchor.constraint(equalTo: container.rightAnchor),
            dateButton.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.45),
            dateButton.topAnchor.constraint(equalTo: dateTxtFld.topAnchor),

            self.bottomAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL)
        ])

        //contraintes du titre et du container
        NSLayoutConstraint.activate([
            titre.topAnchor.constraint(equalTo: self.topAnchor),
            titre.leftAnchor.constraint(equalTo: self.leftAnchor),
            titre.rightAnchor.constraint(equalTo: self.rightAnchor),

            container.topAnchor.constraint(equalTo: titre.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            container.leftAnchor.constraint(equalTo: self.leftAnchor),
            container.rightAnchor.constraint(equalTo: self.rightAnchor),

            //self.bottomAnchor.constraint(equalTo: container.bottomAnchor)

        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func incrementDate(daySup: Int?) -> String {
        let currentDate = Date()
        var interval: TimeInterval
        if daySup != nil {
            interval = TimeInterval(exactly: 86400 * daySup!)!
        } else {
            interval = TimeInterval(exactly: 86400 )!
        }
       
        let jour = currentDate + interval
        
        let formatterDate = DateFormatter()
        formatterDate.locale = Locale(identifier: "fr_FR")
        formatterDate.dateStyle = .medium
        formatterDate.timeStyle = .none
        
        let date = formatterDate.string(from: jour)
        return date
    }
    func setDate(plus day: Int?) {
        self.dateTxtFld.text = self.incrementDate(daySup: day)
    }
}
