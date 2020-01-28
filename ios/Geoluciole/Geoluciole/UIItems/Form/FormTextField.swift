//
//  FormTextField.swift
//  Geoluciole
//
//  Created by Laurent RAYEZ on 24/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FormTextField: UIView, UITextFieldDelegate {

    fileprivate var subLine: UIView!
    var textfield: UITextField!
    var validationData: ((UITextField) -> Bool)?
    var isValid: Bool = false

    init(placeholder: String, keyboardType: UIKeyboardType) {

        super.init(frame: .zero)

        self.textfield = UITextField()
        self.textfield.placeholder = placeholder
        self.textfield.keyboardType = keyboardType
        self.textfield.font = UIFont(name: "Roboto-Regular", size: 20)
        self.textfield.translatesAutoresizingMaskIntoConstraints = false
        self.textfield.rightView = createRightView()
        self.textfield.rightViewMode = .never
        self.textfield.delegate = self
        if keyboardType == .phonePad {
            let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: self.frame.size.width, height: 30)))

            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneBton = UIBarButtonItem(title: Tools.getTranslate(key: "action_validate"), style: .done, target: self, action: #selector(FormTextField.doneButtonAction))
            toolbar.setItems([flexSpace, doneBton], animated: false)
            toolbar.sizeToFit()
            self.textfield.inputAccessoryView = toolbar
        } else {
            self.textfield.autocorrectionType = .no
        }
        if keyboardType != .emailAddress {
            self.textfield.autocapitalizationType = .sentences
        } else {
            self.textfield.autocapitalizationType = .none
        }

        self.addSubview(self.textfield)

        self.subLine = UIView()
        self.subLine.backgroundColor = .black
        self.subLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.subLine)

        NSLayoutConstraint.activate([
            self.textfield.topAnchor.constraint(equalTo: self.topAnchor),
            self.textfield.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.textfield.rightAnchor.constraint(equalTo: self.rightAnchor),

            self.subLine.topAnchor.constraint(equalTo: self.textfield.bottomAnchor),
            self.subLine.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.subLine.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.subLine.heightAnchor.constraint(equalToConstant: 1),

            self.bottomAnchor.constraint(equalTo: self.subLine.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    fileprivate func createRightView() -> UIView {
        // Permet de resize le textfield pour avoir la hauteur.
        self.textfield.sizeToFit()

        // Ce wrap est obligatoire pour l'image
        let v = UIView(frame: CGRect(x: 0, y: 0, width: self.textfield.frame.height, height: self.textfield.frame.height))

        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: v.frame.height, height: v.frame.height))
        iv.image = UIImage(named: "error-exclamation")
        iv.contentMode = .scaleAspectFit
        v.addSubview(iv)

        return v
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.subLine.backgroundColor = .backgroundDefault
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // Pour eviter de poser une condiiton de validation des données on retourne true par défaut
        self.isValid = self.validationData?(self.textfield) ?? true
        if self.isValid {
            self.textfield.rightViewMode = .never
        } else {
            self.textfield.rightViewMode = .always
        }
        self.subLine.backgroundColor = .black
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textfield.resignFirstResponder()
        return true
    }

    @objc fileprivate func doneButtonAction() {
        self.textfield.resignFirstResponder()
    }
}



