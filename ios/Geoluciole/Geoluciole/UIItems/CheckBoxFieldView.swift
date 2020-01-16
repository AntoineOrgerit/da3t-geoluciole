//
//  CheckBoxFieldView.swift
//  Geoluciole
//
//  Created by local192 on 14/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class CheckBoxFieldView: UIView, UIGestureRecognizerDelegate {

    fileprivate var checkbox: CheckBoxView!
    fileprivate var optionLabel: UILabel!
    var onCheckChange: ((CheckBoxFieldView) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.checkbox = CheckBoxView()
        self.checkbox.style = .circle
        self.checkbox.borderStyle = .rounded
        self.checkbox.isUserInteractionEnabled = false
        self.checkbox.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.checkbox)

        self.optionLabel = UILabel()
        self.optionLabel.numberOfLines = 0
        self.optionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.optionLabel.adjustsFontForContentSizeCategory = true
        self.optionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.optionLabel.text = ""
        self.addSubview(self.optionLabel)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CheckBoxFieldView.touchOnCheckBox))
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.delegate = self
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapRecognizer)

        NSLayoutConstraint.activate([

            self.topAnchor.constraint(equalTo: self.optionLabel.topAnchor),
            self.bottomAnchor.constraint(equalTo: self.optionLabel.bottomAnchor),
            self.leftAnchor.constraint(equalTo: self.checkbox.leftAnchor),
            self.rightAnchor.constraint(equalTo: self.optionLabel.rightAnchor),

            self.checkbox.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.checkbox.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.checkbox.heightAnchor.constraint(equalToConstant: 25),
            self.checkbox.widthAnchor.constraint(equalTo: self.checkbox.heightAnchor),

            self.optionLabel.leftAnchor.constraint(equalTo: self.checkbox.rightAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func isChecked() -> Bool {
        return self.checkbox.isChecked
    }

    func setTitleOption(titleOption: String) {
        self.optionLabel.text = titleOption
    }

    @objc fileprivate func touchOnCheckBox() {
        self.setChecked(checked: !self.isChecked())
        self.onCheckChange?(self)
    }

    func setChecked(checked: Bool) {
        self.checkbox.isChecked = checked
    }

    func setStyle(style: CheckBoxView.Style) {
        self.checkbox.style = style
    }

    func setBorderStyle(style: CheckBoxView.BorderStyle) {
        self.checkbox.borderStyle = style
    }

    func setCheckmarkColor(color: UIColor) {
        self.checkbox.checkmarkColor = color
    }

    func setCheckedBorderColor(color: UIColor) {
        self.checkbox.checkedBorderColor = color
    }

    func setUncheckedBorderColor(color: UIColor) {
        self.checkbox.uncheckedBorderColor = color
    }
}
