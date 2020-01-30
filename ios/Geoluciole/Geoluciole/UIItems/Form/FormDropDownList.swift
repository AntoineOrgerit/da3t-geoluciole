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

class FormDropDownList: UIStackView, UITableViewDelegate, UITableViewDataSource {

    fileprivate var data = [String]()
    fileprivate var titre: CustomUILabel!
    fileprivate var button: CustomUIButton!
    fileprivate var tbView: UITableView!
    fileprivate var formTextfield: FormTextField!
    fileprivate var iv: CustomUIImageView!
    fileprivate var optionSelected: String = ""
    fileprivate var optionPrecision: String?
    fileprivate let reusableIdentifier = "OptionTableViewCell"
    fileprivate var isOpen = false
    var onResize: (() -> Void)?

    var isValid: Bool {
        if self.optionSelected == Tools.getTranslate(key: "form_other_option") {
            return self.optionSelected != "" && self.optionPrecision != nil
        } else {
            return self.optionSelected != ""
        }
    }

    var selectedValue: String {
        if self.optionSelected == Tools.getTranslate(key: "form_other_option") {
            return self.optionPrecision ?? ""
        } else {
            return self.optionSelected
        }
    }

    init(title: String, data: [String]) {
        super.init(frame: .zero)

        self.axis = .vertical
        self.spacing = 5

        self.data = data
        self.data.append(Tools.getTranslate(key: "form_other_option"))

        self.titre = CustomUILabel()
        self.titre.text = title
        self.titre.numberOfLines = 0
        self.titre.setStyle(style: .bodyRegular)
        self.titre.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(self.titre)

        let wrap = UIView()
        wrap.translatesAutoresizingMaskIntoConstraints = false
        wrap.layer.borderColor = UIColor.black.cgColor
        wrap.layer.borderWidth = 1
        wrap.layer.cornerRadius = 2
        self.addArrangedSubview(wrap)

        self.button = CustomUIButton()
        self.button.setTitleColor(.black, for: .normal)
        self.button .setTitle(Tools.getTranslate(key: "form_prompt_whom"), for: .normal)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.onClick = { [weak self] button in
            guard let strongSelf = self else {
                return
            }

            if strongSelf.isOpen {
                strongSelf.hideTableView()
            } else {
                strongSelf.showTableView()
            }
        }
        self.button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        wrap.addSubview(self.button)

        self.iv = CustomUIImageView(frame: .zero)
        self.iv.image = UIImage(named: "fleche-bas")
        self.iv.contentMode = .scaleAspectFit
        self.iv.translatesAutoresizingMaskIntoConstraints = false
        self.iv.onClick = { [weak self] imageView in
            guard let strongSelf = self else {
                return
            }

            if strongSelf.isOpen {
                strongSelf.hideTableView()
            } else {
                strongSelf.showTableView()
            }
        }
        wrap.addSubview(self.iv)

        self.tbView = UITableView()
        self.tbView.translatesAutoresizingMaskIntoConstraints = false
        self.tbView.register(UITableViewCell.self, forCellReuseIdentifier: self.reusableIdentifier)
        self.tbView.isHidden = true
        self.tbView.delegate = self
        self.tbView.dataSource = self
        self.addArrangedSubview(self.tbView)

        self.formTextfield = FormTextField(placeholder: Tools.getTranslate(key: "form_placeholder_precision"), keyboardType: .default)
        self.formTextfield.validationData = { [weak self] textfield in
            guard let strongSelf = self else { return false }

            if let text = textfield.text, text != "" {
                strongSelf.optionPrecision = text
                return true
            } else {
                return false
            }
        }
        self.formTextfield.translatesAutoresizingMaskIntoConstraints = false
        self.formTextfield.isHidden = true
        self.addArrangedSubview(self.formTextfield)

        self.button.sizeToFit()

        NSLayoutConstraint.activate([

            self.button.topAnchor.constraint(equalTo: wrap.topAnchor),
            self.button.leftAnchor.constraint(equalTo: wrap.leftAnchor),
            self.button.bottomAnchor.constraint(equalTo: wrap.bottomAnchor),
            self.button.rightAnchor.constraint(equalTo: self.iv.leftAnchor),

            self.iv.centerYAnchor.constraint(equalTo: wrap.centerYAnchor),
            self.iv.rightAnchor.constraint(equalTo: wrap.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.iv.heightAnchor.constraint(equalToConstant: self.button.frame.height / 2),
            self.iv.widthAnchor.constraint(equalTo: iv.heightAnchor),

            self.tbView.topAnchor.constraint(equalTo: wrap.bottomAnchor),
            self.tbView.heightAnchor.constraint(equalToConstant: 150),
            self.tbView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.tbView.rightAnchor.constraint(equalTo: self.rightAnchor),

            self.formTextfield.topAnchor.constraint(equalTo: self.tbView.bottomAnchor),
            self.formTextfield.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.formTextfield.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }

    func showTableView() {
        self.isOpen = true
        self.iv.image = UIImage(named: "fleche-haut")
        UIView.animate(withDuration: 0.3) {
            self.tbView.isHidden = false
        }
        self.onResize?()
    }

    func hideTableView() {
        self.isOpen = false
            self.iv.image = UIImage(named: "fleche-bas")
        self.tbView.isHidden = true
        self.onResize?()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reusableIdentifier, for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lbOption = self.data[indexPath.row]
        self.button.setTitle(lbOption, for: .normal)
        self.optionSelected = lbOption
        self.formTextfield.isHidden = !(self.optionSelected == Tools.getTranslate(key: "form_other_option"))
        self.hideTableView()
    }
}
