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

    enum TypeReponse {
        case radioButton, checkBox
    }


    func setupQuestion(Question: String, typeResp: TypeReponse) {
        let question = CustomUILabel()
        question.setStyleLabel(style: .Form)
        question.text = Question
        
        let reponses = UIView()
        reponses.translatesAutoresizingMaskIntoConstraints = false

        let choix1 = CustomUIButton()
        let choix3 = CheckBoxFieldView()
        choix3.setTitleOption(titleOption: Question)
        let choix2 = CustomUIButton()
        switch typeResp {
        case .radioButton:
            choix1.setStyle(style: .Radio)
            choix2.setStyle(style: .Radio)
        case .checkBox: break
            
        }
        reponses.addSubview(choix1)
        reponses.addSubview(choix2)
        NSLayoutConstraint.activate([
            choix1.topAnchor.constraint(equalTo: reponses.topAnchor),
            choix1.leftAnchor.constraint(equalTo: reponses.leftAnchor),
            choix1.widthAnchor.constraint(equalTo: reponses.widthAnchor, multiplier: 0.5),
            choix1.heightAnchor.constraint(equalToConstant: 25),
            
            choix2.topAnchor.constraint(equalTo: reponses.topAnchor),
            choix2.leftAnchor.constraint(equalTo: choix1.rightAnchor),
            choix2.widthAnchor.constraint(equalTo: reponses.widthAnchor, multiplier: 0.5),
            choix2.heightAnchor.constraint(equalToConstant: 25),
        ])
        self.addSubview(question)
        self.addSubview(reponses)
        
        NSLayoutConstraint.activate([
            question.topAnchor.constraint(equalTo: self.topAnchor),
            question.leftAnchor.constraint(equalTo: self.leftAnchor),
            question.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            question.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            reponses.topAnchor.constraint(equalTo: question.bottomAnchor),
            reponses.leftAnchor.constraint(equalTo: self.leftAnchor),
            reponses.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            reponses.widthAnchor.constraint(equalTo: self.widthAnchor)
            
        ])
    }
}
