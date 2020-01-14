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
        self.optionLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
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
            
            self.topAnchor.constraint(equalTo: self.checkbox.topAnchor),
            self.bottomAnchor.constraint(equalTo: self.checkbox.bottomAnchor),
            self.leftAnchor.constraint(equalTo: self.checkbox.leftAnchor),
            self.rightAnchor.constraint(equalTo: self.optionLabel.rightAnchor),

            self.checkbox.topAnchor.constraint(equalTo: self.topAnchor),
            self.checkbox.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.checkbox.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.checkbox.heightAnchor.constraint(equalToConstant: 25),
            self.checkbox.widthAnchor.constraint(equalTo: self.checkbox.heightAnchor),

            self.optionLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.optionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
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
    
    func setChecked(checked:Bool){
        self.checkbox.isChecked = checked
    }
}
