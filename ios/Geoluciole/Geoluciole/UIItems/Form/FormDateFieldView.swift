//
//  FormDateFieldView.swift
//  Geoluciole
//
//  Created by RAYEZ Laurent on 23/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FormDateFieldView: UIView, UIGestureRecognizerDelegate {

    fileprivate var titre: CustomUILabel!
    fileprivate var container: UIView!
    fileprivate var dateTxtFld: FormTextField!
    fileprivate var dateButton: CustomUIButton!
    fileprivate var datePicker: UIDatePicker!
    var onDateValidate: ((Date) -> Void)?
    var onDateCancel: (() -> Void)?
    var validationData: ((UITextField) -> Bool)!
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
        let doneButton = UIBarButtonItem(title: "Valider", style: .done, target: self, action: #selector(FormDateFieldView.dateValidate))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Annuler", style: .done, target: self, action: #selector(FormDateFieldView.dateCancel))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)

        self.dateTxtFld = FormTextField(placeholder: Tools.convertDate(date: Date()), keyboardType: .default)
        //self.dateTxtFld.text = getDateSystem()
        self.dateTxtFld.translatesAutoresizingMaskIntoConstraints = false
        self.dateTxtFld.isUserInteractionEnabled = false
        self.dateTxtFld.validationData = { [weak self] textField in
            guard let strongSelf = self else { return false }

            return strongSelf.validationData(textField)
        }
        self.container.addSubview(dateTxtFld)

        self.dateTxtFld.textfield.inputAccessoryView = toolbar
        self.dateTxtFld.textfield.inputView = datePicker

        self.dateButton = CustomUIButton()
        self.dateButton.setTitle(Tools.getTranslate(key: "choose_date_button"), for: .normal)
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

            self.dateTxtFld.bottomAnchor.constraint(equalTo: self.dateButton.bottomAnchor),
            self.dateTxtFld.leftAnchor.constraint(equalTo: self.container.leftAnchor),
            self.dateTxtFld.rightAnchor.constraint(equalTo: self.dateButton.leftAnchor, constant: -5),
            self.dateTxtFld.heightAnchor.constraint(equalTo: self.dateButton.heightAnchor, constant: -1),

            self.dateButton.topAnchor.constraint(equalTo: self.container.topAnchor),
            self.dateButton.rightAnchor.constraint(equalTo: self.container.rightAnchor),
            self.dateButton.leftAnchor.constraint(equalTo: self.dateTxtFld.rightAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            self.dateButton.bottomAnchor.constraint(equalTo: self.container.bottomAnchor),


            self.bottomAnchor.constraint(equalTo: self.container.bottomAnchor),
            self.topAnchor.constraint(equalTo: self.titre.topAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func incrementDate(daySup: Int?) -> String {
        let currentDate = Date()
        var interval: TimeInterval
        if daySup != nil {
            interval = TimeInterval(exactly: 86400 * daySup!)!
        } else {
            interval = TimeInterval(exactly: 86400)!
        }

        let jour = currentDate + interval

        let formatterDate = DateFormatter()
        formatterDate.locale = Locale(identifier: "fr_FR")
        formatterDate.dateStyle = .medium
        formatterDate.timeStyle = .none

        let date = formatterDate.string(from: jour)
        return date
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

