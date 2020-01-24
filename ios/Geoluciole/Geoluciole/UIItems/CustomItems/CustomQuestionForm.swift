//
//  CustomQuestionForm.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 21/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class CustomQuestionForm: UIView {
    
    let Oui = CheckBoxFieldView()
    let Non = CheckBoxFieldView()
    let question = CustomUILabel()
    var reponse = UIView()
    
    init(quest: String, typeResp: TypeReponse) {
        super.init(frame: .zero)
        
        self.setupQuestion(Question: quest, typeReponse: typeResp)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    enum TypeReponse {
        case radioButton, checkBox
    }


    func setupQuestion(Question: String, typeReponse: TypeReponse) {

        let question = CustomUILabel()
        question.setStyleLabel(style: .FormTitle2)
        question.numberOfLines = 0
        question.text = Question
        question.translatesAutoresizingMaskIntoConstraints = false

        let reponses = UIView()
        reponses.translatesAutoresizingMaskIntoConstraints = false

        Oui.setTitleOption(titleOption: "OUI")
        Oui.translatesAutoresizingMaskIntoConstraints = false
        
        Oui.onCheckChange = { [weak self] checkBox in
            guard let strongSelf = self else {
                return
            }
            strongSelf.changeCheck(CheckBox:checkBox)
        }
        
        Non.setTitleOption(titleOption: "NON")
        Non.translatesAutoresizingMaskIntoConstraints = false
        Non.onCheckChange = { [weak self] checkBox in
            guard let strongSelf = self else {
                return
            }
            strongSelf.changeCheck(CheckBox:checkBox)
        }
        
        switch typeReponse {
        case .radioButton:
            Oui.setStyle(style: .circle)
            Non.setStyle(style: .circle)
        case .checkBox: break

        }

        reponses.addSubview(Oui)
        reponses.addSubview(Non)

        NSLayoutConstraint.activate([
            Oui.centerYAnchor.constraint(equalTo: reponses.centerYAnchor),
            Oui.rightAnchor.constraint(equalTo: reponses.centerXAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            Oui.leftAnchor.constraint(equalTo: reponses.leftAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),

            Non.centerYAnchor.constraint(equalTo: reponses.centerYAnchor),
            Non.leftAnchor.constraint(equalTo: reponses.centerXAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            Non.rightAnchor.constraint(equalTo: reponses.rightAnchor),
            
            reponses.heightAnchor.constraint(equalTo: Oui.heightAnchor)
            
        ])
        
        self.addSubview(question)
        self.addSubview(reponses)

        NSLayoutConstraint.activate([
            question.topAnchor.constraint(equalTo: self.topAnchor),
            question.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            question.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -Constantes.FIELD_SPACING_HORIZONTAL),

            reponses.topAnchor.constraint(equalTo: question.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            reponses.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            reponses.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),

            self.topAnchor.constraint(equalTo: question.topAnchor),
            self.bottomAnchor.constraint(equalTo: reponses.bottomAnchor)

        ])
    }
    func changeCheck(CheckBox:CheckBoxFieldView) {
        if CheckBox == self.Oui {
            self.Oui.setChecked(checked: true)
            self.Non.setChecked(checked: false)
        }
        if CheckBox == self.Non {
            self.Oui.setChecked(checked: false)
            self.Non.setChecked(checked: true)
        }
    }
    func getReponseCheck() -> Bool{
        if self.Oui.isChecked() && !self.Non.isChecked(){
            return true
        } else {
            return false
        }
    }
}
