//
//  FormDropDownList.swift
//  Geoluciole
//
//  Created by Laurent RAYEZ on 26/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FormDropDownList: UIStackView, UITableViewDelegate, UITableViewDataSource {

    fileprivate var data = [String]()
    fileprivate var titre: CustomUILabel!
    fileprivate var bton: CustomUIButton!
    fileprivate var tbView: UITableView!
    fileprivate var formTextfield: FormTextField!
    fileprivate var optionSelected: String = ""
    fileprivate var optionPrecision: String?
    fileprivate let reusableIdentifier = "OptionTableViewCell"
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

        self.data = data
        self.data.append(Tools.getTranslate(key: "form_other_option"))

        self.titre = CustomUILabel()
        self.titre.text = title
        self.titre.setStyle(style: .bodyRegular)
        self.titre.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(self.titre)

        let wrap = UIView()
        wrap.translatesAutoresizingMaskIntoConstraints = false
        wrap.layer.borderColor = UIColor.black.cgColor
        wrap.layer.borderWidth = 1
        wrap.layer.cornerRadius = 2
        self.addArrangedSubview(wrap)

        self.bton = CustomUIButton()
        self.bton.setTitleColor(.black, for: .normal)
        self.bton .setTitle(Tools.getTranslate(key: "form_prompt_whom"), for: .normal)
        self.bton.translatesAutoresizingMaskIntoConstraints = false
        self.bton.onClick = { [weak self] button in
            guard let strongSelf = self else {
                return
            }
            strongSelf.showTableView()
        }
        self.bton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        wrap.addSubview(self.bton)

        let iv = UIImageView()
        iv.image = UIImage(named: "drop-down")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(iv)

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

        self.bton.sizeToFit()

        NSLayoutConstraint.activate([

            self.bton.topAnchor.constraint(equalTo: wrap.topAnchor),
            self.bton.leftAnchor.constraint(equalTo: wrap.leftAnchor),
            self.bton.bottomAnchor.constraint(equalTo: wrap.bottomAnchor),
            self.bton.rightAnchor.constraint(equalTo: iv.leftAnchor),

            iv.centerYAnchor.constraint(equalTo: wrap.centerYAnchor),
            iv.rightAnchor.constraint(equalTo: wrap.rightAnchor, constant: -Constantes.PAGE_PADDING),
            iv.heightAnchor.constraint(equalToConstant: self.bton.frame.height / 2),
            iv.widthAnchor.constraint(equalTo: iv.heightAnchor),

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
        UIView.animate(withDuration: 0.3) {
            self.arrangedSubviews[2].isHidden = false
        }
        self.onResize?()
    }

    func hideTableView() {
        self.arrangedSubviews[2].isHidden = true
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
        self.bton.setTitle(lbOption, for: .normal)
        self.optionSelected = lbOption
        self.hideTableView()
        self.formTextfield.isHidden = !(self.optionSelected == Tools.getTranslate(key: "form_other_option"))
        self.onResize?()
    }
}
