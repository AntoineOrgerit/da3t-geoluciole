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
    var scrollView: UIScrollView!
    var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //récuperation des dates enregistrées dans la page arrivée/départ (2/4)
        let startCollect = Tools.convertDate(date: self.userPrefs.string(forKey: UserPrefs.KEY_DATE_START_ENGAGEMENT))
        let endCollect = Tools.convertDate(date: self.userPrefs.string(forKey: UserPrefs.KEY_DATE_END_ENGAGEMENT))

        //création du titre
        let titre = CustomTitleForm(titre: "", page: "")
        titre.translatesAutoresizingMaskIntoConstraints = false
        let aff_page: String

        //si la page une n'est pas affichée alors cette page est la 3/3 et le titre doit changer
        if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
            aff_page = "4/4"
        } else {
            aff_page = "3/3"
        }
        titre.setuptitle(title: Tools.getTranslate(key: "form_title"), pg: aff_page)
        self.rootView.addSubview(titre)



        //création de la scrollview pour gérer les petits écrans
        self.scrollView = UIScrollView()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.scrollView)

        //création de la contentView pour le scrollView
        self.contentView = UIView()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.contentView)

        //création du texte explicatif
        self.lbTextExp = UILabel()
        self.lbTextExp.text = Tools.getTranslate(key: "form_explain_validation_period_part_1") + "\n" + Tools.getTranslate(key: "form_explain_validation_period_part_2")
        self.lbTextExp.numberOfLines = 0
        self.lbTextExp.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(lbTextExp)

        //création de la zone contenant l'affichage de la date et le bouton de sélection début de collect
        self.debutCollect = FormDateFieldView(title: Tools.getTranslate(key: "form_title_start_date_validation_period"))
        self.debutCollect.translatesAutoresizingMaskIntoConstraints = false
        self.debutCollect.validationData = { textfield in
            //aucune vérification n'était nécessaire mais la fonction est appelée
            return true
        }

        self.debutCollect.setMinimumDate(date: startCollect)
        self.debutCollect.setMaximumDate(date: endCollect)
        self.contentView.addSubview(self.debutCollect)

        //idem fin de collect
        self.finCollect = FormDateFieldView(title: Tools.getTranslate(key: "form_title_end_date_validation_period"))
        self.finCollect.translatesAutoresizingMaskIntoConstraints = false
        
        self.finCollect.validationData = { textfield in
            //aucune vérification n'était nécessaire mais la fonction est appelée
            return true
        }
        self.finCollect.setMinimumDate(date: startCollect)
        self.finCollect.setMaximumDate(date: endCollect)
        self.contentView.addSubview(self.finCollect)

        //création des boutons de navigation
        let zoneBoutons = FabCustomButton.createButton(type: .valid)
        zoneBoutons.translatesAutoresizingMaskIntoConstraints = false
        zoneBoutons.delegate = self
        self.rootView.addSubview(zoneBoutons)


        //contraintes boutons et titre
        NSLayoutConstraint.activate([
            titre.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            titre.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            titre.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),

            self.scrollView.topAnchor.constraint(equalTo: titre.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.scrollView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: zoneBoutons.topAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),

            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.rootView.widthAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.finCollect.bottomAnchor),

            self.lbTextExp.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.lbTextExp.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.lbTextExp.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constantes.PAGE_PADDING),

            self.debutCollect.topAnchor.constraint(equalTo: self.lbTextExp.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.debutCollect.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.debutCollect.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constantes.PAGE_PADDING),

            self.finCollect.topAnchor.constraint(equalTo: self.debutCollect.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.finCollect.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.finCollect.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constantes.PAGE_PADDING),


            zoneBoutons.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            zoneBoutons.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            zoneBoutons.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING)


        ])
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.contentSize = CGSize(width: self.contentView.bounds.width, height: self.contentView.bounds.height + Constantes.FIELD_SPACING_VERTICAL)
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
