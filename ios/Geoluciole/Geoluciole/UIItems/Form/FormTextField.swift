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



