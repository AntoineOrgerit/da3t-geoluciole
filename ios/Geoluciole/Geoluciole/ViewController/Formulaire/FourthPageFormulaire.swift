//
//  ForthPageFormulaire.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 20/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FourthPageFormulaire: ParentModalViewController, BoutonsPrevDelegate {

    var prevPage: (() -> Void)?

    override func viewDidLoad() {

        super.viewDidLoad()
        let titre4 = CustomTitleForm(titre: "", page: "")
        titre4.translatesAutoresizingMaskIntoConstraints = false

        let aff_page: String
        if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
            aff_page = "4/4"
        } else {
            aff_page = "3/3"
        }

        titre4.setuptitle(title: Constantes.TITRE_FORMULAIRE, pg: aff_page)

        let boutonPrev = fabCustomButton.createButton(type: .prev) as! BoutonsPrev
        boutonPrev.translatesAutoresizingMaskIntoConstraints = false
        boutonPrev.delegate = self

        let zoneDate = FormDateFieldView(titre: "Texte explicatif du concept de période de collecte des données")
        zoneDate.translatesAutoresizingMaskIntoConstraints = false

        self.rootView.addSubview(boutonPrev)
        self.rootView.addSubview(zoneDate)
        self.rootView.addSubview(titre4)


        //contraintes boutons et titre
        NSLayoutConstraint.activate([
            titre4.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            titre4.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            titre4.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),

            zoneDate.topAnchor.constraint(equalTo: titre4.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            zoneDate.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            zoneDate.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            zoneDate.bottomAnchor.constraint(equalTo: boutonPrev.topAnchor),

            boutonPrev.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            boutonPrev.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            boutonPrev.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL)

        ])
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    override func viewDidAppear(_ animated: Bool) {

    }
    func clickPrev(boutonsNext: BoutonsPrev) {
        self.prevPage?()
    }
}
