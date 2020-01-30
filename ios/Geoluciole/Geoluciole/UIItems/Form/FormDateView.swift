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
