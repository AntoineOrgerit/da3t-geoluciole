//Copyright (c) 2020, Martin Allusse and Alexandre Baret and Jessy Barritault and Florian
//Bertonnier and Lisa Fougeron and François Gréau and Thibaud Lambert and Antoine
//Orgerit and Laurent Rayez
//All rights reserved.
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:
//
//* Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//* Neither the name of the copyright holders nor the names of its
//  contributors may be used to endorse or promote products derived
//  from this software without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
//EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
//DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import Foundation
import UIKit

class FormFourthPageViewController: ParentModalViewController, ButtonsPrevNextDelegate {

    var prevPage: (() -> Void)?
    var onValidate: (() -> Void)?
    fileprivate var lbTextExp: CustomUILabel!
    fileprivate var debutCollect: FormDateFieldView!
    fileprivate var finCollect: FormDateFieldView!
    fileprivate var scrollView: UIScrollView!
    fileprivate var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //récuperation des dates enregistrées dans la page arrivée/départ (2/4)
        let startCollect = Tools.convertDate(date: self.userPrefs.string(forKey: UserPrefs.KEY_DATE_START_STAY))
        let endCollect = Tools.convertDate(date: self.userPrefs.string(forKey: UserPrefs.KEY_DATE_END_STAY))

        var titre: FormTitlePage
        
        //si la page une n'est pas affichée alors cette page est la 3/3 et le titre doit changer
        if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
            titre = FormTitlePage(title: Tools.getTranslate(key: "form_title"), pageIndex: "4/4")
        } else {
            titre = FormTitlePage(title: Tools.getTranslate(key: "form_title_anonym"), pageIndex: "3/3")
        }
        titre.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(titre)

        //création de la scrollview pour gérer les petits écrans
        self.scrollView = UIScrollView()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.rootView.addSubview(self.scrollView)

        //création de la contentView pour le scrollView
        self.contentView = UIView()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.contentView)

        //création du texte explicatif
        self.lbTextExp = CustomUILabel()
        self.lbTextExp.setStyle(style: .bodyRegular)
        self.lbTextExp.text = Tools.getTranslate(key: "form_explain_validation_period_part_1") + "\n" + Tools.getTranslate(key: "form_explain_validation_period_part_2")
        self.lbTextExp.numberOfLines = 0
        self.lbTextExp.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(lbTextExp)

        //création de la zone contenant l'affichage de la date et le bouton de sélection début de collect
        self.debutCollect = FormDateFieldView(title: Tools.getTranslate(key: "form_title_start_date_validation_period"))
        self.debutCollect.translatesAutoresizingMaskIntoConstraints = false
        self.debutCollect.setMinimumDate(date: startCollect)
        self.debutCollect.setMaximumDate(date: endCollect)
        self.debutCollect.setDefaultDate(key: UserPrefs.KEY_DATE_START_STAY)
        self.debutCollect.validationData = {[weak self] textfield in
            guard let strongSelf = self else {
                return false
            }
            var incomeDate: Date

            if let date = textfield.text, date != "" {
                incomeDate = Tools.convertDate(date: date)
            } else if let placeholder = textfield.placeholder, placeholder != "" {
                incomeDate = Tools.convertDate(date: placeholder)
            } else {
                incomeDate = Date()
            }
            
            let result = incomeDate.timeIntervalSince1970 <= strongSelf.finCollect.date.timeIntervalSince1970
            if result {
                UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_DATE_START_ENGAGEMENT, value: Tools.convertDate(date: incomeDate))

            }
            return result
            
        }
        self.contentView.addSubview(self.debutCollect)

        //idem fin de collect
        self.finCollect = FormDateFieldView(title: Tools.getTranslate(key: "form_title_end_date_validation_period"))
        self.finCollect.translatesAutoresizingMaskIntoConstraints = false
        self.finCollect.setMinimumDate(date: startCollect)
        self.finCollect.setMaximumDate(date: endCollect)
        self.finCollect.setDefaultDate(key: UserPrefs.KEY_DATE_END_STAY)
        self.finCollect.validationData = {[weak self] textfield in
            guard let strongSelf = self else {
                return false
            }
            var incomeDate: Date

            if let date = textfield.text, date != "" {
                incomeDate = Tools.convertDate(date: date)
            } else if let placeholder = textfield.placeholder, placeholder != "" {
                incomeDate = Tools.convertDate(date: placeholder)
            } else {
                incomeDate = Date()
            }
            
            let result = incomeDate.timeIntervalSince1970 >= strongSelf.debutCollect.date.timeIntervalSince1970
            if result {
                UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_DATE_END_ENGAGEMENT, value: Tools.convertDate(date: incomeDate))

            }
            return result
            
        }
        self.contentView.addSubview(self.finCollect)

        //création des boutons de navigation
        let zoneBoutons = FabricCustomButton.createButton(type: .valid)
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

    func boutonsPrevNext(boutonsPrevNext: ButtonsPrevNext, onPrevious: Bool) {
        self.prevPage?()
    }

    func boutonsPrevNext(boutonsPrevNext: ButtonsPrevNext, onNext: Bool) {
        self.onValidate?()
    }

    func validationPage() -> Bool {
        return self.debutCollect.isValid && self.finCollect.isValid
    }
}
