//
//  FormDateView.swift
//  Geoluciole
//
//  Created by Laurent RAYEZ on 23/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FormDateView: UIView {

    var isValid: Bool {
        return self.zoneDateArrivee.isValid && self.zoneDateDepart.isValid
    }
    var zoneDateArrivee: FormDateFieldView!
    var zoneDateDepart: FormDateFieldView!

    init() {
        super.init(frame: .zero)

        let now = Date()

        self.zoneDateArrivee = FormDateFieldView(title: Tools.getTranslate(key: "form_in_city_title"))
        self.zoneDateArrivee.translatesAutoresizingMaskIntoConstraints = false
        self.zoneDateArrivee.setMaximumDate(date: now)
        self.zoneDateArrivee.validationData = { [weak self] textfield in
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
            
            let result = incomeDate.timeIntervalSince1970 <= strongSelf.zoneDateDepart.date.timeIntervalSince1970
            if result {
                UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_DATE_START_STAY, value: Tools.convertDate(date: incomeDate))

            }
            return result
        }
        self.addSubview(zoneDateArrivee)

        self.zoneDateDepart = FormDateFieldView(title: Tools.getTranslate(key: "form_out_city_title"))
        self.zoneDateDepart.translatesAutoresizingMaskIntoConstraints = false
        self.zoneDateDepart.setMinimumDate(date: now)
        self.zoneDateDepart.validationData = { [weak self] textfield in
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

            let result = incomeDate.timeIntervalSince1970 >= strongSelf.zoneDateArrivee.date.timeIntervalSince1970
            if result {
                UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_DATE_END_STAY, value: Tools.convertDate(date: incomeDate))

            }
            return result
        }
        self.addSubview(zoneDateDepart)

        NSLayoutConstraint.activate([

            self.zoneDateArrivee.topAnchor.constraint(equalTo: self.topAnchor),
            self.zoneDateArrivee.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.zoneDateArrivee.leftAnchor.constraint(equalTo: self.leftAnchor),

            self.zoneDateDepart.topAnchor.constraint(equalTo: self.zoneDateArrivee.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.zoneDateDepart.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.zoneDateDepart.rightAnchor.constraint(equalTo: self.rightAnchor),

            self.bottomAnchor.constraint(equalTo: zoneDateDepart.bottomAnchor),
            self.topAnchor.constraint(equalTo: zoneDateArrivee.topAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
