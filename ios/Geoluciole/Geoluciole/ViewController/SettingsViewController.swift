//
//  SettingsViewController.swift
//  Geoluciole
//
//  Created by local192 on 09/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var type_engagement : UISegmentedControl!
    @IBOutlet var langue : UISegmentedControl!
    @IBOutlet var label : UITextField!
    @IBOutlet var switchData: UISwitch!
    
    let param = Params.getInstance().param
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.delegate = self
        label.text = param.string(forKey: "duree_engagement")
        langue.selectedSegmentIndex = param.integer(forKey: "langue")
        type_engagement.selectedSegmentIndex = param.integer(forKey: "type_engagement")
        
        langue.addTarget(self, action: #selector(SettingsViewController.switchLangue(_:)), for: .valueChanged)
        type_engagement.addTarget(self, action: #selector(SettingsViewController.switchTypeEngagement(_:)), for: .valueChanged)
    }
    
    // Function de changement des paramètres
    
    @objc func switchLangue(_ sender: UISegmentedControl){
        param.set(sender.selectedSegmentIndex, forKey: "langue")
    }
    
    @objc func switchTypeEngagement(_ sender: UISegmentedControl){
        param.set(sender.selectedSegmentIndex, forKey: "type_engagement")
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        param.set(sender.text, forKey: "duree_engagement")
    }
    
    @IBAction func switchSender(sender: UISwitch){
        param.set(sender.isOn, forKey: "send_data")
    }
}
