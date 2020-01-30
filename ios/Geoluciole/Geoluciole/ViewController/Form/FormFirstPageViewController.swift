//    Copyright (c) 2020, Martin Allusse and Alexandre Baret and Jessy Barritault and Florian
//    Bertonnier and Lisa Fougeron and François Gréau and Thibaud Lambert and Antoine
//    Orgerit and Laurent Rayez
//    All rights reserved.
//    Redistribution and use in source and binary forms, with or without
//    modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright
//      notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//    * Neither the name of the University of California, Berkeley nor the
//      names of its contributors may be used to endorse or promote products
//      derived from this software without specific prior written permission.
//
//    THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
//    EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//    DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
//    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import Foundation
import UIKit

class FormFirstPageViewController: ParentModalViewController, ButtonsPrevNextDelegate {
    
    //cette fonction est nécessaire pour récupérer les éléments de la classe qui appelle celle-ci. Cette fonction sera définie dans la classe d'instanciation de celle-ci
    var onNextButton: (() -> Void)? //? => potentiellement nil => ne sera pas déclenchée si nul nécessite une vérification de type if
    fileprivate var titre: FormTitlePage!
    fileprivate var lblNom: FormTextField!
    fileprivate var lblPrenom: FormTextField!
    fileprivate var lblAddMail: FormTextField!
    fileprivate var lblTelephone: FormTextField!
    //Dictionnaire de récupération des données pour les transmettre au FormPageViewController ; initialisé à vide
    fileprivate var data = [String: Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //titre de la page
        
        self.titre = FormTitlePage(title: Tools.getTranslate(key: "form_title"), pageIndex: "1/4")
        self.titre.translatesAutoresizingMaskIntoConstraints = false

        self.rootView.addSubview(self.titre)
        
        //champ d'inscription du prénom
        self.lblNom = FormTextField(placeholder: Tools.getTranslate(key: "form_lastname"), keyboardType: .default)
        self.lblNom.translatesAutoresizingMaskIntoConstraints = false

        // Définition de la fonction de validation. La fonction est appelée dans la calsse FormTextField. La vérification porte sur la présence de texte dans le champs
        self.lblNom.validationData = { txtfield in

            if let text = txtfield.text {
                return text != ""
            } else {
                return false
            }
        }
        self.rootView.addSubview(self.lblNom)
        
        //idem que lblNom
        self.lblPrenom = FormTextField(placeholder: Tools.getTranslate(key: "form_firstname"), keyboardType: .default)
        self.lblPrenom.translatesAutoresizingMaskIntoConstraints = false
        self.lblPrenom.validationData = { txtfield in

            if let text = txtfield.text {
                return text != ""
            } else {
                return false
            }

        }
        self.rootView.addSubview(self.lblPrenom)

        self.lblAddMail = FormTextField(placeholder: Tools.getTranslate(key: "form_mail"), keyboardType: .emailAddress)
        self.lblAddMail.translatesAutoresizingMaskIntoConstraints = false

        // La vérification porte sur la syntaxe d'une adresse mail
        self.lblAddMail.validationData = { txtfield in

            func isValid(_ email: String) -> Bool {
                let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", Constantes.REGEX_MAIL)
                return emailTest.evaluate(with: email)
            }

            if let text = txtfield.text {
                return isValid(text)
            } else {
                return false
            }
        }
        self.rootView.addSubview(self.lblAddMail)

        self.lblTelephone = FormTextField(placeholder: Tools.getTranslate(key: "form_phone"), keyboardType: .phonePad)
        self.lblTelephone.translatesAutoresizingMaskIntoConstraints = false
        self.lblTelephone.validationData = { txtfield in

            func isValid(_ phoneNumber: String) -> Bool {
                let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", Constantes.REGEX_PHONE)
                return emailTest.evaluate(with: phoneNumber)
            }
            
            if let text = txtfield.text {
                return isValid(text)
            } else {
                return false
            }
        }
        self.rootView.addSubview(self.lblTelephone)
        //utilisation d'une fabrique pour récupérer le type de bouton nécessaire. Le type est une énumération déclarée
        //dans la classe FabricCustomButton
        let btonZone = FabricCustomButton.createButton(type: .next)
        btonZone.translatesAutoresizingMaskIntoConstraints = false
        //les delegates sont gérées en bas de ce fichier
        btonZone.delegate = self
        self.rootView.addSubview(btonZone)

        NSLayoutConstraint.activate([
            self.titre.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.titre.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.titre.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),

            self.lblNom.topAnchor.constraint(equalTo: self.titre.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.lblNom.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.lblNom.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),

            self.lblPrenom.topAnchor.constraint(equalTo: self.lblNom.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.lblPrenom.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.lblPrenom.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),

            self.lblAddMail.topAnchor.constraint(equalTo: self.lblPrenom.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.lblAddMail.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.lblAddMail.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),

            self.lblTelephone.topAnchor.constraint(equalTo: self.lblAddMail.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.lblTelephone.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.lblTelephone.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),

            btonZone.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            btonZone.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            btonZone.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING)
        ])
    }
    //fonction duppliquée, voir pour factoriser dans une classe parente uniquement pour les formulaires
    func getFormDataInfoGen() -> [String: Any]{
        data["nom"] = self.lblNom.textfield.text
        data["prenom"] = self.lblPrenom.textfield.text
        data["mail"] = self.lblAddMail.textfield.text
        data["phone"] = self.lblTelephone.textfield.text
        return data
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func validationPage() -> Bool {
        return self.lblAddMail.isValid && self.lblNom.isValid && self.lblPrenom.isValid && self.lblTelephone.isValid
    }

    func boutonsPrevNext(boutonsPrevNext: ButtonsPrevNext, onNext: Bool) {
        self.onNextButton?()
    }
}
