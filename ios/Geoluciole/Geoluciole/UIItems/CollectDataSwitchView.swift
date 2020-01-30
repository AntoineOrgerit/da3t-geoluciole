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

class CollectDataSwitchView: UIView {

    fileprivate var titleLabel: CustomUILabel!
    fileprivate var offLabel: CustomUILabel!
    fileprivate var onLabel: CustomUILabel!
    fileprivate var switchData: UISwitch!
    fileprivate let userPrefs = UserPrefs.getInstance()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Title label
        self.titleLabel = CustomUILabel()
        self.titleLabel.text = Tools.getTranslate(key: "data_collection")
        self.titleLabel.setStyle(style: .subtitleBold)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
        
        let wrapSwitch = UIView()
        wrapSwitch.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapSwitch)
        
        // Off Label
        self.offLabel = CustomUILabel()
        self.offLabel.text = Tools.getTranslate(key: "data_collection_deactivated")
        self.offLabel.setStyle(style: .bodyItalic)
        self.offLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapSwitch.addSubview(self.offLabel)
        
        // On Label
        self.onLabel = CustomUILabel()
        self.onLabel.text = Tools.getTranslate(key: "data_collection_activated")
        self.onLabel.setStyle(style: .bodyItalic)
        self.onLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapSwitch.addSubview(self.onLabel)
        
        // Switch data
        self.switchData = UISwitch()
        self.switchData.translatesAutoresizingMaskIntoConstraints = false
        self.switchData.setOn(self.userPrefs.bool(forKey: UserPrefs.KEY_SEND_DATA), animated: false)
        self.switchData.addTarget(self, action: #selector(CollectDataSwitchView.switchSenderData), for: .touchUpInside)
        wrapSwitch.addSubview(self.switchData)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalTo: self.titleLabel.heightAnchor, constant: self.switchData.frame.height + Constantes.FIELD_SPACING_VERTICAL),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            wrapSwitch.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            wrapSwitch.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            wrapSwitch.heightAnchor.constraint(equalTo: self.switchData.heightAnchor),
            wrapSwitch.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            self.switchData.centerXAnchor.constraint(equalTo: wrapSwitch.centerXAnchor),
            self.switchData.topAnchor.constraint(equalTo: wrapSwitch.topAnchor),
            
            self.onLabel.leftAnchor.constraint(equalTo: self.switchData.rightAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            self.onLabel.centerYAnchor.constraint(equalTo: self.switchData.centerYAnchor),
            
            self.offLabel.rightAnchor.constraint(equalTo: self.switchData.leftAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            self.offLabel.centerYAnchor.constraint(equalTo: self.switchData.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc fileprivate func switchSenderData() {
        self.userPrefs.setPrefs(key: UserPrefs.KEY_SEND_DATA, value: self.switchData.isOn)
        
        // On démarre le timer de localisation si la collecte est autorisée
        if self.switchData.isOn {
            LocationHandler.getInstance().startLocationTracking()
            CustomTimer.getInstance().startTimerLocalisation()
        } else {
            LocationHandler.getInstance().stopLocationTracking()
            CustomTimer.getInstance().stopTimerLocation()
        }
    }

    func setSwitch(value: Bool) {
        switchData.setOn(value, animated: false)
    }
}
