//
//  FormYesNoQuestion.swift
//  Geoluciole
//
//  Created by Laurent RAYEZ on 21/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FormYesNoQuestion: UIView {

    let yesAnswer = CheckBoxFieldView()
    let noAnswer = CheckBoxFieldView()
    let question = CustomUILabel()

    var isValid: Bool {
        return self.noAnswer.isChecked() || self.yesAnswer.isChecked()
    }

    init(question: String) {
        super.init(frame: .zero)
        
        let questionLabel = CustomUILabel()
        questionLabel.setStyle(style: .bodyRegular)
        questionLabel.numberOfLines = 0
        questionLabel.text = question
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(questionLabel)

        let answersWrap = UIView()
        answersWrap.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(answersWrap)

        self.yesAnswer.setTitleOption(titleOption: Tools.getTranslate(key: "action_yes"))
        self.yesAnswer.translatesAutoresizingMaskIntoConstraints = false
        self.yesAnswer.setStyle(style: .circle)
        self.yesAnswer.onCheckChange = { [weak self] checkBox in
            guard let strongSelf = self else { return }
            strongSelf.changeCheck(CheckBox: checkBox)
        }
        answersWrap.addSubview(self.yesAnswer)

        self.noAnswer.setTitleOption(titleOption: Tools.getTranslate(key: "action_no"))
        self.noAnswer.setStyle(style: .circle)
        self.noAnswer.translatesAutoresizingMaskIntoConstraints = false
        self.noAnswer.onCheckChange = { [weak self] checkBox in
            guard let strongSelf = self else { return }
            strongSelf.changeCheck(CheckBox: checkBox)
        }
        answersWrap.addSubview(self.noAnswer)

        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: self.topAnchor),
            questionLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            questionLabel.rightAnchor.constraint(equalTo: self.rightAnchor),

            answersWrap.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            answersWrap.centerXAnchor.constraint(equalTo: questionLabel.centerXAnchor),
            answersWrap.leftAnchor.constraint(equalTo: self.yesAnswer.leftAnchor),
            answersWrap.rightAnchor.constraint(equalTo: self.noAnswer.rightAnchor),
            answersWrap.bottomAnchor.constraint(equalTo: self.yesAnswer.bottomAnchor),

            self.topAnchor.constraint(equalTo: questionLabel.topAnchor),
            self.bottomAnchor.constraint(equalTo: answersWrap.bottomAnchor),

            self.yesAnswer.topAnchor.constraint(equalTo: answersWrap.topAnchor),
            self.yesAnswer.leftAnchor.constraint(equalTo: answersWrap.leftAnchor),
            self.yesAnswer.bottomAnchor.constraint(equalTo: answersWrap.bottomAnchor),

            self.noAnswer.topAnchor.constraint(equalTo: answersWrap.topAnchor),
            self.noAnswer.leftAnchor.constraint(equalTo: self.yesAnswer.rightAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            self.noAnswer.bottomAnchor.constraint(equalTo: answersWrap.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    fileprivate func changeCheck(CheckBox: CheckBoxFieldView) {
        if CheckBox == self.yesAnswer {
            self.yesAnswer.setChecked(checked: true)
            self.noAnswer.setChecked(checked: false)
        }
        if CheckBox == self.noAnswer {
            self.yesAnswer.setChecked(checked: false)
            self.noAnswer.setChecked(checked: true)
        }
    }
}
