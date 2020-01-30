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

class FormDateFieldView: UIView, UIGestureRecognizerDelegate {

    fileprivate var titre: CustomUILabel!
    fileprivate var container: UIView!
    var dateTxtFld: FormTextField!
    fileprivate var dateButton: CustomUIButton!
    fileprivate var datePicker: UIDatePicker!

    var onDateValidate: ((Date) -> Void)?
    var onDateCancel: (() -> Void)?
    var validationData: ((UITextField) -> Bool)?
    var isValid: Bool {
        return self.dateTxtFld.isValid
    }
    var date: Date {
        if let text = self.dateTxtFld.textfield.text, text != "" {
            return Tools.convertDate(date: text)
        } else if let placeholder = self.dateTxtFld.textfield.placeholder, placeholder != "" {
            return Tools.convertDate(date: placeholder)
        } else {
            return Date()
        }
    }

    init(title: String) {
        super.init(frame: .zero)

        self.titre = CustomUILabel()
        self.titre.setStyle(style: .bodyRegular)
        self.titre.text = title
        self.titre.numberOfLines = 0
        self.titre.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titre)

        self.container = UIView()
        self.container.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.container)

        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.addTarget(self, action: #selector(FormDateFieldView.dateChange), for: .valueChanged)
        self.datePicker.calendar = Calendar.current
        self.datePicker.locale = Tools.getPreferredLocale()

        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: Tools.getTranslate(key: "action_validate"), style: .done, target: self, action: #selector(FormDateFieldView.dateValidate))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: Tools.getTranslate(key: "alert_cancel"), style: .done, target: self, action: #selector(FormDateFieldView.dateCancel))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)

        self.dateTxtFld = FormTextField(placeholder: Tools.convertDate(date: Date()), keyboardType: .default)
        self.dateTxtFld.translatesAutoresizingMaskIntoConstraints = false
        self.dateTxtFld.isUserInteractionEnabled = false
        self.dateTxtFld.validationData = { [weak self] textField in
            guard let strongSelf = self else { return false }

            return strongSelf.validationData?(textField) ?? true
        }
        self.container.addSubview(dateTxtFld)

        self.dateTxtFld.textfield.textAlignment = .center
        self.dateTxtFld.textfield.inputAccessoryView = toolbar
        self.dateTxtFld.textfield.inputView = datePicker

        self.dateButton = CustomUIButton()
        self.dateButton.setTitle(Tools.getTranslate(key: "form_btn_date"), for: .normal)
        self.dateButton.setStyle(style: .dateField)
        self.dateButton.translatesAutoresizingMaskIntoConstraints = false
        self.dateButton.isUserInteractionEnabled = false
        self.container.addSubview(self.dateButton)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(FormDateFieldView.touchOnDateField))
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.delegate = self
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapRecognizer)

        //contraintes à l'intérieur du container
        NSLayoutConstraint.activate([

            self.titre.topAnchor.constraint(equalTo: self.topAnchor),
            self.titre.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.titre.rightAnchor.constraint(equalTo: self.rightAnchor),

            self.container.topAnchor.constraint(equalTo: self.titre.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.container.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.container.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            self.dateTxtFld.bottomAnchor.constraint(equalTo: self.container.bottomAnchor),
            self.dateTxtFld.leftAnchor.constraint(equalTo: self.container.leftAnchor),
            self.dateTxtFld.heightAnchor.constraint(equalTo: self.dateButton.heightAnchor, constant: -1),
            self.dateTxtFld.widthAnchor.constraint(equalTo: self.container.widthAnchor, multiplier: 0.6),

            self.dateButton.topAnchor.constraint(equalTo: self.container.topAnchor),
            self.dateButton.rightAnchor.constraint(equalTo: self.container.rightAnchor),
            self.dateButton.leftAnchor.constraint(equalTo: self.dateTxtFld.rightAnchor, constant: 5),
            self.dateButton.bottomAnchor.constraint(equalTo: self.container.bottomAnchor)
        ])
    }

    func setDefaultDate(key: String) {
        let strDate = UserPrefs.getInstance().string(forKey: key)
        let date = Tools.convertDate(date: strDate)

        self.dateTxtFld.textfield.placeholder = strDate
        self.datePicker.setDate(date, animated: false)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc fileprivate func touchOnDateField() {
        self.dateTxtFld.textfield.becomeFirstResponder()
    }

    @objc fileprivate func dateCancel() {
        self.dateTxtFld.textfield.resignFirstResponder()
        if let date = self.datePicker.minimumDate {
            self.dateTxtFld.textfield.text = Tools.convertDate(date: date)
        }
        self.onDateCancel?()
    }

    @objc fileprivate func dateValidate() {
        self.dateTxtFld.textfield.resignFirstResponder()
        if self.validationData?(self.dateTxtFld.textfield) ?? true {
            if let dateText = self.dateTxtFld.textfield.text, dateText != "" {
                self.onDateValidate?(Tools.convertDate(date: dateText))
                self.dateChange()
            } else if let placeholder = self.dateTxtFld.textfield.placeholder, placeholder != "" {
                self.onDateValidate?(Tools.convertDate(date: placeholder))
                self.dateChange()
            } else {
                self.onDateValidate?(Date())
                self.dateChange()
            }
        }
    }

    @objc fileprivate func dateChange() {

        self.dateTxtFld.textfield.text = Tools.convertDate(date: self.datePicker.date)
    }

    func setMaximumDate(date: Date) {
        self.datePicker.maximumDate = date
    }
    func setMinimumDate(date: Date) {
        self.datePicker.minimumDate = date
    }
}

