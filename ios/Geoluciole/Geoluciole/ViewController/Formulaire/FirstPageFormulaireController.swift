//
//  FirstPageController.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 20/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FirstPageFormulaireController: ParentModalViewController {

    var onNextButton: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        let titre = CustomTitleForm()
        titre.translatesAutoresizingMaskIntoConstraints = false
        titre.setuptitle(title: "Formulaire", pg: "1/4")

        let lblNom = CustomTextFieldForm()
        lblNom.setUpTextField(text: "Nom")
        lblNom.translatesAutoresizingMaskIntoConstraints = false
        
        let lblPrenom = CustomTextFieldForm()
        lblPrenom.setUpTextField(text: "Prénom")
        lblPrenom.translatesAutoresizingMaskIntoConstraints = false
        
        let lblAddMail = CustomTextFieldForm()
        lblAddMail.setUpTextField(text: "Email")
        lblAddMail.translatesAutoresizingMaskIntoConstraints = false
        
        let btonNext = CustomUIButton(frame: .zero)
        btonNext.setStyle(style: .active)
        btonNext.setTitle("Suivant", for: .normal)
        btonNext.translatesAutoresizingMaskIntoConstraints = false
        btonNext.onClick = { [weak self] boutton in
            guard let strongSelf = self else { return }

            strongSelf.onNextButton?()
        }

        self.rootView.addSubview(titre)
//        self.rootView.addSubview(lblNom)
//        self.rootView.addSubview(lblPrenom)
//        self.rootView.addSubview(lblAddMail)
//        self.rootView.addSubview(btonNext)

        NSLayoutConstraint.activate([
            titre.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            titre.widthAnchor.constraint(equalTo: self.rootView.widthAnchor, multiplier: 0.75),
            titre.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),

//            lblNom.topAnchor.constraint(equalTo: titre.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
//            lblNom.widthAnchor.constraint(equalTo: self.rootView.widthAnchor, multiplier: 0.75),
//            lblNom.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
//
//            lblPrenom.topAnchor.constraint(equalTo: lblNom.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
//            lblPrenom.widthAnchor.constraint(equalTo: self.rootView.widthAnchor, multiplier: 0.75),
//            lblPrenom.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
//
//            lblAddMail.topAnchor.constraint(equalTo: lblPrenom.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
//            lblAddMail.widthAnchor.constraint(equalTo: self.rootView.widthAnchor, multiplier: 0.75),
//            lblAddMail.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
//
//            btonNext.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
//            btonNext.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),

        ])

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
