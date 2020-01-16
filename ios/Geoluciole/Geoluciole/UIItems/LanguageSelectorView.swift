//
//  LanguageSelectorView.swift
//  Geoluciole
//
//  Created by local192 on 14/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class LanguageSelectorView: UIView {

    fileprivate var frenchOption: CheckBoxFieldView!
    fileprivate var englishOption: CheckBoxFieldView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        let titleLabel = UILabel()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Langue de l'application"
        self.addSubview(titleLabel)
        
        let languageSelected = UserPrefs.getInstance().string(forKey: UserPrefs.KEY_LANGUAGE)

        frenchOption = CheckBoxFieldView()
        frenchOption.setTitleOption(titleOption: Constantes.LANGUAGE_FRENCH)
        
        if languageSelected == Constantes.LANGUAGE_FRENCH {
            frenchOption.setChecked(checked: true)
        }
    
        frenchOption.translatesAutoresizingMaskIntoConstraints = false
        frenchOption.onCheckChange = { [weak self] checkBox in
            guard let strongSelf = self else { return }

            strongSelf.valueChange(checkBox: checkBox)
        }
        self.addSubview(frenchOption)

        englishOption = CheckBoxFieldView()
        englishOption.setTitleOption(titleOption: Constantes.LANGUAGE_ENGLISH)
        
        if languageSelected == Constantes.LANGUAGE_ENGLISH {
            englishOption.setChecked(checked: true)
        }
        
        englishOption.translatesAutoresizingMaskIntoConstraints = false
        englishOption.onCheckChange = { [weak self] checkBox in
            guard let strongSelf = self else { return }

            strongSelf.valueChange(checkBox: checkBox)
        }
        self.addSubview(englishOption)

        NSLayoutConstraint.activate([

            self.bottomAnchor.constraint(equalTo: frenchOption.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor),

            frenchOption.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            frenchOption.leftAnchor.constraint(equalTo: self.leftAnchor),

            englishOption.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            englishOption.leftAnchor.constraint(equalTo: frenchOption.rightAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    fileprivate func valueChange(checkBox:CheckBoxFieldView) {
        if checkBox == self.frenchOption {
            self.saveFrenchChoice()
        } else if checkBox == self.englishOption {
            self.saveEnglishChoice()
        }
    }
    
    fileprivate func saveFrenchChoice() {
        // Décocher toutes les options
        self.englishOption.setChecked(checked: false)
        
        // Cocher la vraie option
        self.frenchOption.setChecked(checked: true)
        
        // Save les valeurs
        UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_LANGUAGE, value: Constantes.LANGUAGE_FRENCH)
    }
    
    fileprivate func saveEnglishChoice() {
        self.frenchOption.setChecked(checked: false)
        
        self.englishOption.setChecked(checked: true)
        
        UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_LANGUAGE, value: Constantes.LANGUAGE_ENGLISH)
    }
}
