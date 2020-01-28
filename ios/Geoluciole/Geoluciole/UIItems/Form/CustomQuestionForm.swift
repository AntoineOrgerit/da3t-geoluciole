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

    let yesAnswer = CheckBoxFieldView()
    let noAnswer = CheckBoxFieldView()
    let question = CustomUILabel()

    init(quest: String) {
        super.init(frame: .zero)

        self.setupQuestion(Question: quest)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupQuestion(Question: String) {

        let question = CustomUILabel()
        question.setStyle(style: .bodyItalic)
        question.numberOfLines = 0
        question.text = Question
        question.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(question)

        let answersWrap = UIView()
        answersWrap.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(answersWrap)

        yesAnswer.setTitleOption(titleOption: "OUI")
        yesAnswer.translatesAutoresizingMaskIntoConstraints = false
        yesAnswer.setStyle(style: .circle)
        yesAnswer.onCheckChange = { [weak self] checkBox in
            guard let strongSelf = self else {
                return
            }
            strongSelf.changeCheck(CheckBox: checkBox)
        }
        answersWrap.addSubview(yesAnswer)

        noAnswer.setTitleOption(titleOption: "NON")
        noAnswer.setStyle(style: .circle)
        noAnswer.translatesAutoresizingMaskIntoConstraints = false
        noAnswer.onCheckChange = { [weak self] checkBox in
            guard let strongSelf = self else {
                return
            }
            strongSelf.changeCheck(CheckBox: checkBox)
        }
        answersWrap.addSubview(noAnswer)

        NSLayoutConstraint.activate([
            question.topAnchor.constraint(equalTo: self.topAnchor),
            question.leftAnchor.constraint(equalTo: self.leftAnchor),
            question.rightAnchor.constraint(equalTo: self.rightAnchor),

            answersWrap.topAnchor.constraint(equalTo: question.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            answersWrap.centerXAnchor.constraint(equalTo: question.centerXAnchor),
            answersWrap.leftAnchor.constraint(equalTo: yesAnswer.leftAnchor),
            answersWrap.rightAnchor.constraint(equalTo: noAnswer.rightAnchor),
            answersWrap.bottomAnchor.constraint(equalTo: yesAnswer.bottomAnchor),

            self.topAnchor.constraint(equalTo: question.topAnchor),
            self.bottomAnchor.constraint(equalTo: answersWrap.bottomAnchor)

        ])

        NSLayoutConstraint.activate([
            yesAnswer.topAnchor.constraint(equalTo: answersWrap.topAnchor),
            yesAnswer.leftAnchor.constraint(equalTo: answersWrap.leftAnchor),
            yesAnswer.bottomAnchor.constraint(equalTo: answersWrap.bottomAnchor),

            noAnswer.topAnchor.constraint(equalTo: answersWrap.topAnchor),
            noAnswer.leftAnchor.constraint(equalTo: yesAnswer.rightAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            noAnswer.bottomAnchor.constraint(equalTo: answersWrap.bottomAnchor)
        ])

    }
    func changeCheck(CheckBox: CheckBoxFieldView) {
        if CheckBox == self.yesAnswer {
            self.yesAnswer.setChecked(checked: true)
            self.noAnswer.setChecked(checked: false)
        }
        if CheckBox == self.noAnswer {
            self.yesAnswer.setChecked(checked: false)
            self.noAnswer.setChecked(checked: true)
        }
    }
    func getReponseCheck() -> Bool {
        if self.yesAnswer.isChecked() && !self.noAnswer.isChecked() {
            return true
        } else {
            return false
        }
    }
}
