//
//  SecondPageFormulaire.swift
//  Geoluciole
//
//  Created by RAYEZ Laurent on 20/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class SecondPageFormulaire: ParentModalViewController, BoutonsPrevNextDelegate {


    var onNextButton: (() -> Void)?
    var onPreviousButton: (() -> Void)?
    fileprivate var scrollView: UIScrollView!
    fileprivate var contentView: UIView!
    fileprivate var formulaire: FormDateView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let titre2 = CustomTitleForm(titre: "", page: "")
        titre2.translatesAutoresizingMaskIntoConstraints = false

        let aff_page: String
        var boutonsNav: BoutonsPrevNext!
        if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
            aff_page = "2/4"
            boutonsNav = FabCustomButton.createButton(type: .nextPrev)
        } else {
            aff_page = "1/3"
            boutonsNav = FabCustomButton.createButton(type: .next)
        }
        titre2.setuptitle(title: Tools.getTranslate(key: "form_title"), pg: aff_page)

        boutonsNav.delegate = self
        boutonsNav.translatesAutoresizingMaskIntoConstraints = false

        
        self.formulaire = FormDateView()
        self.formulaire.translatesAutoresizingMaskIntoConstraints = false

        

        self.rootView.addSubview(titre2)
        self.rootView.addSubview(formulaire)
        self.rootView.addSubview(boutonsNav)

        NSLayoutConstraint.activate([
            //position du titre 2 dans la rootview
            titre2.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            titre2.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            titre2.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),

            //position du formulaire dans le contentView
            self.formulaire.topAnchor.constraint(equalTo: titre2.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.formulaire.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.formulaire.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),

            //position des boutons dans la rootView / scrollview
            boutonsNav.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            boutonsNav.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            boutonsNav.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL)
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
    func validationPage() -> Bool{
        return self.formulaire.isValid
    }
}
