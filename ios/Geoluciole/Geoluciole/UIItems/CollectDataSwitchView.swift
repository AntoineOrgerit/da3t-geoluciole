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
        self.titleLabel.text = "Collecte des données"
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        self.titleLabel.adjustsFontForContentSizeCategory = true
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
        
        let wrapSwitch = UIView()
        wrapSwitch.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapSwitch)
        
        // Off Label
        self.offLabel = UILabel()
        self.offLabel.text = "OFF"
        self.offLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        self.offLabel.adjustsFontForContentSizeCategory = true
        self.offLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapSwitch.addSubview(self.offLabel)
        
        // On Label
        self.onLabel = UILabel()
        self.onLabel.text = "ON"
        self.onLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        self.onLabel.adjustsFontForContentSizeCategory = true
        self.onLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapSwitch.addSubview(self.onLabel)
        
        // Switch data
        self.switchData = UISwitch()
        self.switchData.translatesAutoresizingMaskIntoConstraints = false
       
        self.switchData.addTarget(self, action: #selector(CollectDataSwitchView.switchSenderData(sender:)), for: .touchUpInside)
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

    @objc func switchSenderData(sender: UISwitch) {
        param.set(sender.isOn, forKey: "send_data")
        print("coucou")
    }

    func setSwitch(value: Bool) {
        switchData.setOn(value, animated: true)
    }
}
