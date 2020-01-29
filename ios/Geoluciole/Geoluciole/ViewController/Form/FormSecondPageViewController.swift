//
//  FormSecondPageViewController.swift
//  Geoluciole
//
//  Created by Laurent RAYEZ on 20/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FormSecondPageViewController: ParentModalViewController, ButtonsPrevNextDelegate {

    var onNextButton: (() -> Void)?
    var onPreviousButton: (() -> Void)?
    fileprivate var scrollView: UIScrollView!
    fileprivate var contentView: UIView!
    fileprivate var formulaire: FormDateView!
    
    fileprivate var formData = [String:String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        var boutonsNav: ButtonsPrevNext
        let titre: FormTitlePage!
        
        if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
            titre = FormTitlePage(title: Tools.getTranslate(key: "form_title"), pageIndex: "2/4")
            boutonsNav = FabricCustomButton.createButton(type: .nextPrev)
        } else {
            titre = FormTitlePage(title: Tools.getTranslate(key: "form_title_anonym"), pageIndex: "1/3")
            boutonsNav = FabricCustomButton.createButton(type: .next)
        }
        
        titre.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(titre)

        boutonsNav.delegate = self
        boutonsNav.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(boutonsNav)

        self.formulaire = FormDateView()
        self.formulaire.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.formulaire)
        
        NSLayoutConstraint.activate([
            //position du titre 2 dans la rootview
            titre.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            titre.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            titre.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),

            //position du formulaire dans le contentView
            self.formulaire.topAnchor.constraint(equalTo: titre.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.formulaire.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.formulaire.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),

            //position des boutons dans la rootView / scrollview
            boutonsNav.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            boutonsNav.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            boutonsNav.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
        ])
    }
    func getFormDat() -> [String: Any]{
        formData["1"] = self.formulaire.zoneDateArrivee.dateTxtFld.textfield!.text
        formData["2"] = self.formulaire.zoneDateDepart.dateTxtFld.textfield!.text
        return formData
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func boutonsPrevNext(boutonsPrevNext: ButtonsPrevNext, onNext: Bool) {
        self.onNextButton?()
    }

    func boutonsPrevNext(boutonsPrevNext: ButtonsPrevNext, onPrevious: Bool) {
        self.onPreviousButton?()
    }

    func validationPage() -> Bool {
        return self.formulaire.isValid
    }
}
