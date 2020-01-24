//
//  ThirdPageFormulaire.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 20/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class ThirdPageFormulaire: ParentModalViewController, BoutonsPrevNextDelegate {

    var onNextButton: (() -> Void)?
    var onPreviousButton: (() -> Void)?
    var scrollView: UIScrollView!
    var contentView: UIView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Permet de resize le content pour permettre le scroll
        scrollView.contentSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height + Constantes.FIELD_SPACING_VERTICAL)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let titre3 = CustomTitleForm(titre: "", page: "")
        titre3.translatesAutoresizingMaskIntoConstraints = false

        let aff_page: String
        if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
            aff_page = "3/4"
        } else {
            aff_page = "2/3"
        }

        titre3.setuptitle(title: "Formulaire", pg: aff_page)

        // ScollView pour le texte
        self.scrollView = UIScrollView()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.scrollView)
        
        
        self.contentView = UIView()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let formulaire = FormulaireScrollView()
        formulaire.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(formulaire)

        let zoneButton = fabCustomButton.createButton(type: .nextPrev) as! BoutonsPrevNext
        zoneButton.delegate = self
        zoneButton.translatesAutoresizingMaskIntoConstraints = false

        self.rootView.addSubview(titre3)
        self.rootView.addSubview(self.scrollView)
        self.rootView.addSubview(zoneButton)
        
        //contrainte titre et bouttons
        NSLayoutConstraint.activate([
            
            titre3.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            titre3.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            titre3.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),

            zoneButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            zoneButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            zoneButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),

        ])
        
        //contraintes scrollview
        NSLayoutConstraint.activate([

            self.scrollView.topAnchor.constraint(equalTo: titre3.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            self.scrollView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            self.scrollView.bottomAnchor.constraint(equalTo: zoneButton.topAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),

            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.rootView.widthAnchor),
            self.contentView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: formulaire.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            formulaire.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            formulaire.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            formulaire.leftAnchor.constraint(equalTo: self.contentView.leftAnchor)
        ])

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func boutonsPrevNext(boutonsPrevNext: BoutonsPrevNext, onNext: Bool) {
        self.onNextButton?()
    }

    func boutonsPrevNext(boutonsPrevNext: BoutonsPrevNext, onPrevious: Bool) {
        self.onPreviousButton?()
    }
}
