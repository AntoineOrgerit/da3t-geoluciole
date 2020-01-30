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

class ShowLevelView: UIView {

    fileprivate var levelNumberLabel: CustomUILabel!
    fileprivate var progressBar: UIProgressView!
    fileprivate let progressBarHeight: CGFloat = 15
    var onProgressBarFinish: (()-> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Label indiquant le niveau
        self.levelNumberLabel = CustomUILabel()
        self.levelNumberLabel.text = Tools.getTranslate(key: "stay_progression")
        self.levelNumberLabel.setStyle(style: .subtitleBold)
        self.levelNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        self.levelNumberLabel.textAlignment = .left
        self.addSubview(self.levelNumberLabel)

        // progressview
        self.progressBar = UIProgressView()
        self.progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.progressBar.layer.cornerRadius = self.progressBarHeight / 2
        self.progressBar.clipsToBounds = true
        self.progressBar.progressTintColor = .colorProgressBar
        self.progressBar.setProgress(0, animated: true)
        self.addSubview(self.progressBar)

        NSLayoutConstraint.activate([

            self.heightAnchor.constraint(equalTo: self.levelNumberLabel.heightAnchor, constant: Constantes.FIELD_SPACING_VERTICAL + self.progressBarHeight),

            self.levelNumberLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.levelNumberLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.levelNumberLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.levelNumberLabel.rightAnchor.constraint(equalTo: self.rightAnchor),

            self.progressBar.heightAnchor.constraint(equalToConstant: self.progressBarHeight),
            self.progressBar.topAnchor.constraint(equalTo: self.levelNumberLabel.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.progressBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            self.progressBar.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func setProgress(value: Float) {
        self.progressBar.progress = value
        if self.progressBar.progress >= 1 {
            self.onProgressBarFinish?()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
