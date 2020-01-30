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

class SettingsDateFieldView: UIView, UIGestureRecognizerDelegate {

    fileprivate var titleLabel: CustomUILabel!
    fileprivate var dateLabel: UITextView!
    fileprivate var datePicker: UIDatePicker!
    var onDateValidate: ((Date) -> Void)?
    var onDateCancel: (() -> Void)?
    var validationData: ((UITextView) -> Bool)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.titleLabel = CustomUILabel()
        self.titleLabel.setStyle(style: .bodyRegular)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.text = ""
        self.titleLabel.textAlignment = .left
        self.addSubview(self.titleLabel)

        let wrapDate = UIView()
        wrapDate.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapDate)

        //élément utilisé pour afficher la date
        self.dateLabel = UITextView()
        self.dateLabel.tintColor = .clear
        self.dateLabel.font = UIFont(name: "Roboto-Italic", size: 16)
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dateLabel.text = Tools.convertDate(date: Date())
        self.dateLabel.isScrollEnabled = false
        self.dateLabel.isUserInteractionEnabled = false
        wrapDate.addSubview(self.dateLabel)

        //élément qui affiche un sélecteur de date
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .dateAndTime
        //code commenté pour pour étudier la gestion du cancel dans le choix des dates - TODO
        //self.datePicker.addTarget(self, action: #selector(SettingsDateFieldView.dateChange), for: .valueChanged)
        self.datePicker.calendar = Calendar.current
        self.datePicker.locale = Tools.getPreferredLocale()

        //ToolBar du picker pour valider la date et fermer la vue
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: Tools.getTranslate(key: "action_validate"), style: .done, target: self, action: #selector(SettingsDateFieldView.dateValidate))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: Tools.getTranslate(key: "alert_cancel"), style: .done, target: self, action: #selector(SettingsDateFieldView.dateCancel))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)

        self.dateLabel.inputAccessoryView = toolbar
        self.dateLabel.inputView = datePicker

        let dropDown = UIImageView()
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        dropDown.contentMode = .scaleAspectFit
        dropDown.image = UIImage(named: "fleche-bas")
        wrapDate.addSubview(dropDown)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsDateFieldView.touchOnDateField))
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.delegate = self
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapRecognizer)

        NSLayoutConstraint.activate([

            self.bottomAnchor.constraint(equalTo: wrapDate.bottomAnchor),

            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor),

            wrapDate.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            wrapDate.leftAnchor.constraint(equalTo: self.leftAnchor),
            wrapDate.rightAnchor.constraint(equalTo: self.rightAnchor),
            wrapDate.widthAnchor.constraint(equalTo: self.widthAnchor),
            wrapDate.bottomAnchor.constraint(equalTo: self.dateLabel.bottomAnchor),

            self.dateLabel.topAnchor.constraint(equalTo: wrapDate.topAnchor),
            self.dateLabel.leftAnchor.constraint(equalTo: wrapDate.leftAnchor),
            self.dateLabel.rightAnchor.constraint(equalTo: dropDown.leftAnchor),

            dropDown.centerYAnchor.constraint(equalTo: self.dateLabel.centerYAnchor),
            dropDown.rightAnchor.constraint(equalTo: wrapDate.rightAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            dropDown.widthAnchor.constraint(equalToConstant: 15),
            dropDown.heightAnchor.constraint(equalTo: dropDown.widthAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setTitle(title: String) {
        self.titleLabel.text = title
    }

    @objc fileprivate func touchOnDateField() {
        self.dateLabel.becomeFirstResponder()
    }

    @objc fileprivate func dateCancel() {
        self.dateLabel.resignFirstResponder()
        //commenté pour revoir l'annulation de l'affichage de la date choisie. TODO
//        if let date = self.datePicker.minim {
//            self.dateLabel.text = Tools.convertDate(date: date)
//        }
        self.onDateCancel?()
    }

    @objc fileprivate func dateValidate() {
        self.dateLabel.resignFirstResponder()
        if self.validationData?(self.dateLabel) ?? true {
            self.dateChange()
            self.onDateValidate?(Tools.convertDate(date: self.dateLabel.text))
            self.setDefaultDatePicker(date: self.dateLabel!.text)
        }

    }

    @objc fileprivate func dateChange() {

        self.dateLabel.text = Tools.convertDate(date: self.datePicker.date)

    }

    func getDate() -> Date {
        return self.datePicker.date
    }

    func setDate(date: Date) {
        self.datePicker.date = date
    }

    func setMaximumDate(date: Date) {
        self.datePicker.maximumDate = date
    }

    func setMinimumDate(date: Date) {
        self.datePicker.minimumDate = date
    }

    func setDateLabel(date: String) {
        self.dateLabel.text = date
    }
    func getDateLabel() -> String {
        return self.dateLabel.text
    }
    func setDefaultDatePicker(date: String) {
        self.datePicker.setDate(Tools.convertDate(date: date), animated: false)
    }
}
