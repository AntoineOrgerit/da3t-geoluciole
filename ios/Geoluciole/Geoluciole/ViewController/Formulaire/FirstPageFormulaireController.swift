//
//  FirstPageController.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 20/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FirstPageFormulaireController: ParentModalViewController, BoutonsPrevNextDelegate {

    var onNextButton: (() -> Void)?

    fileprivate var titre: CustomTitleForm!
    
    fileprivate var lblNom: FormTextField!

    fileprivate var lblPrenom: FormTextField!

    fileprivate var lblAddMail: FormTextField!

    fileprivate var lblTelephone: FormTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.titre = CustomTitleForm(titre: Tools.getTranslate(key: "form_title"), page: "1/4")
        self.titre.translatesAutoresizingMaskIntoConstraints = false

        self.rootView.addSubview(self.titre)

        self.lblNom = FormTextField(placeholder: Tools.getTranslate(key: "form_lastname"), keyboardType: .default)
        self.lblNom.translatesAutoresizingMaskIntoConstraints = false
        self.lblNom.validationData = { txtfield in
            
            if let text = txtfield.text {
                 return text != ""
            } else {
                return false
            }
          
        }
        self.rootView.addSubview(self.lblNom)

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
        self.lblAddMail.validationData = {txtfield in

            func isValid(_ email: String) -> Bool {
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

                let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
                return emailTest.evaluate(with: email)
            }
            
            if let text = txtfield.text {
                return isValid(text)
            } else {
                return false
            }
        }
        self.rootView.addSubview(self.lblAddMail)


        self.lblTelephone = FormTextField(placeholder: Tools.getTranslate(key: "form_tel"), keyboardType: .phonePad)
        self.lblTelephone.translatesAutoresizingMaskIntoConstraints = false
        self.lblTelephone.validationData = { txtfield in
          
            func isValid(_ phoneNumber: String) -> Bool {
                let emailRegEx = "[0-9]{1,15}"

                let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
                return emailTest.evaluate(with: phoneNumber)
            }
            if let text = txtfield.text {
                 return isValid(text)
            } else {
                return false
            }
        }
        self.rootView.addSubview(self.lblTelephone)


        let btonZone = FabCustomButton.createButton(type: .next)
        btonZone.translatesAutoresizingMaskIntoConstraints = false
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
            btonZone.leftAnchor.constraint(equalTo: self.rootView.leftAnchor)

        ])

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
    func boutonsPrevNext(boutonsPrevNext: BoutonsPrevNext, onNext: Bool) {
        self.onNextButton?()
    }
}
