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

class LastTrophyView: UIView {

    fileprivate var trophy: CustomUIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        let label = CustomUILabel()
        label.setStyle(style: .subtitleBold)
        label.text = Tools.getTranslate(key: "last_achievement_obtained")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        self.trophy = CustomUIImageView(frame: .zero)
        self.trophy.image = UIImage(named: "no-badge")
        self.trophy.translatesAutoresizingMaskIntoConstraints = false
        self.trophy.contentMode = .scaleAspectFit
        self.addSubview(self.trophy)

        NSLayoutConstraint.activate([
            
            label.widthAnchor.constraint(equalTo: self.widthAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor),
            label.rightAnchor.constraint(equalTo: self.rightAnchor),
            label.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.trophy.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.trophy.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            self.trophy.heightAnchor.constraint(equalTo: self.trophy.widthAnchor),
            self.trophy.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            self.bottomAnchor.constraint(equalTo: self.trophy.bottomAnchor)
        ])
    }

    func setImage(nom: String) {
        self.trophy.image = UIImage(named: nom) ?? UIImage(named: "no-img")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
