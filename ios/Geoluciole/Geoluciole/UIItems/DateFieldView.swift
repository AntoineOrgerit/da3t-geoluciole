//
//  DateFieldView.swift
//  Geoluciole
//
//  Created by local192 on 14/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class DateFieldView: UIView, UIGestureRecognizerDelegate {

    fileprivate var titleLabel: UILabel!
    fileprivate var dateLabel: UITextView!
    fileprivate var datePicker: UIDatePicker!
    var onDateValidate: ((Date) -> Void)?
    var onDateCancel: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.titleLabel = UILabel()
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.titleLabel.adjustsFontForContentSizeCategory = true
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.text = ""
        self.titleLabel.textAlignment = .left
        self.addSubview(self.titleLabel)

        let wrapDate = UIView()
        wrapDate.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapDate)

        self.dateLabel = UITextView()
        self.dateLabel.tintColor = .clear
        self.dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.dateLabel.adjustsFontForContentSizeCategory = true
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dateLabel.text = Tools.convertDate(date: Date())
        self.dateLabel.isScrollEnabled = false
        self.dateLabel.isUserInteractionEnabled = false
        wrapDate.addSubview(self.dateLabel)

        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.addTarget(self, action: #selector(DateFieldView.dateChange), for: .valueChanged)
        self.datePicker.calendar = Calendar.current
        self.datePicker.locale = Tools.getPreferredLocale()

        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Valider", style: .done, target: self, action: #selector(DateFieldView.dateValidate))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Annuler", style: .done, target: self, action: #selector(DateFieldView.dateCancel))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)

        self.dateLabel.inputAccessoryView = toolbar
        self.dateLabel.inputView = datePicker

        let dropDown = UIImageView()
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        dropDown.contentMode = .scaleAspectFit
        dropDown.image = UIImage(named: "drop-down")
        wrapDate.addSubview(dropDown)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DateFieldView.touchOnDateField))
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
        if let date = self.datePicker.minimumDate {
            self.dateLabel.text = Tools.convertDate(date: date)
        }
        self.onDateCancel?()
    }

    @objc fileprivate func dateValidate() {
        self.dateLabel.resignFirstResponder()
        self.onDateValidate?(Tools.convertDate(date: self.dateLabel.text))
    }

    @objc fileprivate func dateChange() {
        self.dateLabel.text = Tools.convertDate(date: self.datePicker.date)
    }

    func setMinimumDate(date: Date) {
        self.datePicker.minimumDate = date
    }

    func setDateLabel(date: String) {
        self.dateLabel.text = date
    }
}
