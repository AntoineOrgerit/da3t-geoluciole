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

class StatsView: UIView {

    fileprivate var uniteMetrique: CustomUILabel!
    fileprivate var lbTitle: CustomUILabel!
    fileprivate var lbDistance: CustomUILabel!
    fileprivate var wrapData: UIView!
    fileprivate var lbValeurDist: CustomUILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.lbTitle = CustomUILabel()
        self.lbTitle.text = Tools.getTranslate(key: "text_stats_title")
        self.lbTitle.setStyle(style: .subtitleBold)
        self.lbTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.lbTitle)

        self.lbDistance = CustomUILabel()
        self.lbDistance.text = Tools.getTranslate(key: "text_distance")
        self.lbDistance.setStyle(style: .bodyRegular)
        self.lbDistance.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.lbDistance)

        self.wrapData = UIView()
        self.wrapData.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.wrapData)

        self.lbValeurDist = CustomUILabel()
        self.lbValeurDist.text = "0"
        self.lbValeurDist.setStyle(style: .bodyItalic)
        self.lbValeurDist.translatesAutoresizingMaskIntoConstraints = false
        self.wrapData.addSubview(self.lbValeurDist)

        self.uniteMetrique = CustomUILabel()
        self.uniteMetrique.text = "Km"
        self.uniteMetrique.setStyle(style: .bodyItalic)
        self.uniteMetrique.translatesAutoresizingMaskIntoConstraints = false
        self.wrapData.addSubview(self.uniteMetrique)
        
        self.setValeurDist()

        NSLayoutConstraint.activate([

            self.bottomAnchor.constraint(equalTo: self.wrapData.bottomAnchor),

            self.lbTitle.topAnchor.constraint(equalTo: self.topAnchor),
            self.lbTitle.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.lbTitle.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.lbTitle.widthAnchor.constraint(equalTo: self.widthAnchor),

            self.lbDistance.topAnchor.constraint(equalTo: self.lbTitle.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.lbDistance.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            self.lbDistance.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),

            self.wrapData.topAnchor.constraint(equalTo: self.lbTitle.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.wrapData.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.wrapData.leftAnchor.constraint(equalTo: self.lbDistance.rightAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            self.wrapData.bottomAnchor.constraint(equalTo: self.lbValeurDist.bottomAnchor),

            self.lbValeurDist.topAnchor.constraint(equalTo: self.wrapData.topAnchor),
            self.lbValeurDist.leftAnchor.constraint(equalTo: self.wrapData.leftAnchor),

            self.uniteMetrique.topAnchor.constraint(equalTo: self.wrapData.topAnchor),
            self.uniteMetrique.leftAnchor.constraint(equalTo: self.lbValeurDist.rightAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            self.uniteMetrique.bottomAnchor.constraint(equalTo: self.wrapData.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setValeurDist() {
        var valeurDist = Tools.getDistStat()
        
        if valeurDist < 1000 {
            self.uniteMetrique.text = "m"
        } else {
            valeurDist = Tools.roundDist(valeurDist / 1000, places: 2)
            self.uniteMetrique.text = "km"
        }

        self.lbValeurDist.text = String(valeurDist)
    }
}
