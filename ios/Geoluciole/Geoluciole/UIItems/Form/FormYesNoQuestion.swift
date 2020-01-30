//    Copyright (c) 2020, Martin Allusse and Alexandre Baret and Jessy Barritault and Florian
//    Bertonnier and Lisa Fougeron and François Gréau and Thibaud Lambert and Antoine
//    Orgerit and Laurent Rayez
//    All rights reserved.
//    Redistribution and use in source and binary forms, with or without
//    modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright
//      notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//    * Neither the name of the University of California, Berkeley nor the
//      names of its contributors may be used to endorse or promote products
//      derived from this software without specific prior written permission.
//
//    THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
//    EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//    DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
//    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import Foundation
import UIKit

class FormYesNoQuestion: UIView {

    let yesAnswer = CheckBoxFieldView()
    let noAnswer = CheckBoxFieldView()
    let question = CustomUILabel()

    var isValid: Bool {
        return self.noAnswer.isChecked() || self.yesAnswer.isChecked()
    }
    var selectedValue: String {
        var r: String!
        if self.noAnswer.isChecked() {
            r = self.noAnswer.optionLabel.text ?? ""
        } else if self.yesAnswer.isChecked() {
            r = self.yesAnswer.optionLabel.text ?? ""
        }
        return r
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
