//
//  ForthPageFormulaire.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 20/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FourthPageFormulaire: ParentModalViewController, BoutonsPrevNextDelegate {

    var prevPage: (() -> Void)?
    var onValider: (() -> Void)?
    var lbTextExp: UILabel!
    var debutCollect: FormDateFieldView!
    var finCollect: FormDateFieldView!

    override func viewDidLoad() {
        super.viewDidLoad()


        let startCollect = Tools.convertDate(date: self.userPrefs.string(forKey: UserPrefs.KEY_DATE_START_ENGAGEMENT))
        let endCollect = Tools.convertDate(date: self.userPrefs.string(forKey: UserPrefs.KEY_DATE_END_ENGAGEMENT))

        let titre = CustomTitleForm(titre: "", page: "")
        titre.translatesAutoresizingMaskIntoConstraints = false
        let aff_page: String
        if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
            aff_page = "4/4"
        } else {
            aff_page = "3/3"
        }
        titre.setuptitle(title: Tools.getTranslate(key: "form_title"), pg: aff_page)
        self.rootView.addSubview(titre)

        self.lbTextExp = UILabel()
        self.lbTextExp.text = Tools.getTranslate(key: "form_text_explicatif")
        self.lbTextExp.numberOfLines = 0
        self.lbTextExp.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(lbTextExp)

        self.debutCollect = FormDateFieldView(title: Tools.getTranslate(key: "deb_collect"))
        self.debutCollect.translatesAutoresizingMaskIntoConstraints = false
        self.debutCollect.validationData = { textfield in
            //aucune vérification n'était nécessaire mais la fonction est appelée
            return true
        }

        self.debutCollect.setMinimumDate(date: startCollect)
        self.debutCollect.setMaximumDate(date: endCollect)
        self.rootView.addSubview(self.debutCollect)

        self.finCollect = FormDateFieldView(title: Tools.getTranslate(key: "end_collect"))
        self.finCollect.translatesAutoresizingMaskIntoConstraints = false
        self.finCollect.validationData = { textfield in
            //aucune vérification n'était nécessaire mais la fonction est appelée
            return true
        }
        self.finCollect.setMinimumDate(date: startCollect)
        self.finCollect.setMaximumDate(date: endCollect)
        self.rootView.addSubview(self.finCollect)

        let zoneBoutons = FabCustomButton.createButton(type: .valid)
        zoneBoutons.translatesAutoresizingMaskIntoConstraints = false
        zoneBoutons.delegate = self
        self.rootView.addSubview(zoneBoutons)


        //contraintes boutons et titre
        NSLayoutConstraint.activate([
            titre.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            titre.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            titre.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),

            self.lbTextExp.topAnchor.constraint(equalTo: titre.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.lbTextExp.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.lbTextExp.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),


            self.debutCollect.topAnchor.constraint(equalTo: self.lbTextExp.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.debutCollect.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.debutCollect.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),

            self.finCollect.topAnchor.constraint(equalTo: self.debutCollect.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.finCollect.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.finCollect.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),

            zoneBoutons.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            zoneBoutons.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            zoneBoutons.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING)


        ])
    }

    func boutonsPrevNext(boutonsPrevNext: BoutonsPrevNext, onPrevious: Bool) {
        self.prevPage?()
    }

    func boutonsPrevNext(boutonsPrevNext: BoutonsPrevNext, onNext: Bool) {
        self.onValider?()
    }
    func validationPage() -> Bool {
        return self.debutCollect.isValid && self.finCollect.isValid
    }
}
