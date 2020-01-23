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
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let titleLabel = CustomUILabel()
        titleLabel.setStyle(style: .subtitleBold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = Tools.getTranslate(key: "app_language")
        self.addSubview(titleLabel)
        
        self.frenchOption = CheckBoxFieldView()
        self.frenchOption.setTitleOption(titleOption: Tools.getTranslate(key: "french_language"))
        self.frenchOption.translatesAutoresizingMaskIntoConstraints = false
        self.frenchOption.onCheckChange = { [weak self] checkBox in
            guard let strongSelf = self else { return }

            strongSelf.valueChange(checkBox)
        }
        self.addSubview(self.frenchOption)
        
        self.englishOption = CheckBoxFieldView()
        self.englishOption.setTitleOption(titleOption: Tools.getTranslate(key: "english_language"))
        
        self.englishOption.translatesAutoresizingMaskIntoConstraints = false
        self.englishOption.onCheckChange = { [weak self] checkBox in
            guard let strongSelf = self else { return }

            strongSelf.valueChange(checkBox)
        }
        self.addSubview(self.englishOption)
        
        let languageSelected = (UserPrefs.getInstance().object(forKey: UserPrefs.APPLE_LANGUAGE_KEY) as! NSArray).firstObject as! String
        
        if languageSelected.contains("fr") {
            self.frenchOption.setChecked(checked: true)
        } else {
            self.englishOption.setChecked(checked: true)
        }

        NSLayoutConstraint.activate([

            self.bottomAnchor.constraint(equalTo: self.frenchOption.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor),

            self.frenchOption.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.frenchOption.leftAnchor.constraint(equalTo: self.leftAnchor),

            self.englishOption.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.englishOption.leftAnchor.constraint(equalTo: self.frenchOption.rightAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    fileprivate func valueChange(_ checkBox:CheckBoxFieldView) {
        if checkBox == self.frenchOption {
            self.saveFrenchChoice()
            
            if Constantes.DEBUG {
                print("Changement de langue : FRANÇAIS ACTIVÉ")
            }
        } else if checkBox == self.englishOption {
            self.saveEnglishChoice()
            
            if Constantes.DEBUG {
                print("Changement de langue : ANGLAIS ACTIVÉ")
            }
        }
        self.onChange?()
        
    }
    
    fileprivate func saveFrenchChoice() {
        // Décocher toutes les options
        self.englishOption.setChecked(checked: false)
        
        // Cocher la vraie option
        self.frenchOption.setChecked(checked: true)
        
        // Save les valeurs
        self.userPref.setPrefs(key: UserPrefs.APPLE_LANGUAGE_KEY, value: ["fr_FR"])
        self.userPref.sync()
    }
    
    fileprivate func saveEnglishChoice() {
        self.frenchOption.setChecked(checked: false)
        
        self.englishOption.setChecked(checked: true)
        
        UserPrefs.getInstance().setPrefs(key: UserPrefs.APPLE_LANGUAGE_KEY, value: ["en_EN"])
        self.userPref.sync()
    }
}
