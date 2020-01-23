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
    fileprivate let userPref = UserPrefs.getInstance()
    var onChange: (()-> Void)?
    
    
    func changeLanguage(langue: String) {
        self.userPref.setPrefs(key: UserPrefs.APPLE_LANGUAGE_KEY, value: [langue])
        self.userPref.sync()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let titleLabel = CustomUILabel()
        titleLabel.setStyle(style: .subtitleBold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = Tools.getTranslate(key: "app_language")
        self.addSubview(titleLabel)
        
        let languageSelected = UserPrefs.getInstance().object(forKey: UserPrefs.APPLE_LANGUAGE_KEY) as! NSArray
        
        let t = languageSelected.firstObject as! String
        frenchOption = CheckBoxFieldView()
        frenchOption.setTitleOption(titleOption: NSLocalizedString("french_language", comment: ""))
        
        if t == "fr" {
            frenchOption.setChecked(checked: true)
            changeLanguage(langue: "fr")
            print("Swap to fr")
        }
    
        frenchOption.translatesAutoresizingMaskIntoConstraints = false
        frenchOption.onCheckChange = { [weak self] checkBox in
            guard let strongSelf = self else { return }

            strongSelf.valueChange(checkBox: checkBox)
        }
        self.addSubview(frenchOption)

        englishOption = CheckBoxFieldView()
        englishOption.setTitleOption(titleOption: Tools.getTranslate(key: "english_language"))
        
        if t == "en" {
            englishOption.setChecked(checked: true)
            changeLanguage(langue: "en")
            print("Swap to en")
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
        self.onChange?()
        
    }
    
    fileprivate func saveFrenchChoice() {
        // Décocher toutes les options
        self.englishOption.setChecked(checked: false)
        
        // Cocher la vraie option
        self.frenchOption.setChecked(checked: true)
        
        // Save les valeurs
        UserPrefs.getInstance().setPrefs(key: UserPrefs.APPLE_LANGUAGE_KEY, value: ["fr"])
    }
    
    fileprivate func saveEnglishChoice() {
        self.frenchOption.setChecked(checked: false)
        
        self.englishOption.setChecked(checked: true)
        
        UserPrefs.getInstance().setPrefs(key: UserPrefs.APPLE_LANGUAGE_KEY, value: ["en"])
    }
}
