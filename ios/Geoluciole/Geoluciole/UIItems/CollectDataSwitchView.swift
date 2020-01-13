//
//  CollectDataSwitch.swift
//  Geoluciole
//
//  Created by Jessy BARRITAULT on 13/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class CollectDataSwitchView: UIView {

    fileprivate var titleLabel: UILabel!
    fileprivate var offLabel: UILabel!
    fileprivate var onLabel: UILabel!
    fileprivate var switchData: UISwitch!
    let param = Params.getInstance().param
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Title label
        self.titleLabel = UILabel()
        self.titleLabel.text = "Collecte des données :"
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        self.titleLabel.adjustsFontForContentSizeCategory = true
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
        
        // Off Label
        self.offLabel = UILabel()
        self.offLabel.text = "OFF"
        self.offLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        self.offLabel.adjustsFontForContentSizeCategory = true
        self.offLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.offLabel)
        
        // On Label
        self.onLabel = UILabel()
        self.onLabel.text = "ON"
        self.onLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        self.onLabel.adjustsFontForContentSizeCategory = true
        self.onLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.onLabel)
        
        // Switch data
        self.switchData = UISwitch()
        self.switchData.translatesAutoresizingMaskIntoConstraints = false
        let send = param.bool(forKey: "send_data")
        self.switchData.setOn(send, animated: true)
        self.switchData.addTarget(self, action: #selector(CollectDataSwitchView.switchSenderData(sender:)), for: .touchUpInside)
        self.addSubview(self.switchData)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalTo: self.switchData.heightAnchor),
            
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constantes.PAGE_PADDING_HORIZONTAL),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.switchData.centerYAnchor),
            
            self.onLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Constantes.PAGE_PADDING_HORIZONTAL),
            self.onLabel.centerYAnchor.constraint(equalTo: self.switchData.centerYAnchor),
            
            self.switchData.rightAnchor.constraint(equalTo: self.onLabel.leftAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            self.switchData.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.offLabel.rightAnchor.constraint(equalTo: self.switchData.unsafelyUnwrapped.leftAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            self.offLabel.centerYAnchor.constraint(equalTo: self.switchData.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc func switchSenderData(sender: UISwitch) {
        param.set(sender.isOn, forKey: "send_data")
        print("coucou")
    }

    func setSwitch(value: Bool) {
        switchData.setOn(value, animated: true)
    }
}
