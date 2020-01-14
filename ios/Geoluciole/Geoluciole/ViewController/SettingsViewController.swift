//
//  SettingsViewController.swift
//  Geoluciole
//
//  Created by local192 on 09/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: ParentViewController, UITextFieldDelegate {

    @IBOutlet var type_engagement: UISegmentedControl!
    @IBOutlet var langue: UISegmentedControl!
    @IBOutlet var label: UITextField!
    @IBOutlet var switchDataParam: UISwitch!
    fileprivate var deleteAccount: CustomUIButton!

    let param = Params.getInstance().param

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let send = param.bool(forKey: "send_data")
        switchDataParam.setOn(send, animated: true)

        // Modification style bouton


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let send = param.bool(forKey: "send_data")
        switchDataParam.setOn(send, animated: true)
        self.label.delegate = self
        label.text = param.string(forKey: "duree_engagement")
        langue.selectedSegmentIndex = param.integer(forKey: "langue")
        type_engagement.selectedSegmentIndex = param.integer(forKey: "type_engagement")

        langue.addTarget(self, action: #selector(SettingsViewController.switchLangue(_:)), for: .valueChanged)
        type_engagement.addTarget(self, action: #selector(SettingsViewController.switchTypeEngagement(_:)), for: .valueChanged)

        // bouton de suppression de compte
        self.deleteAccount = CustomUIButton(frame: .zero)
        self.deleteAccount.setTitle("Supprimer le compte", for: .normal)
        self.deleteAccount.setStyle(color: .buttonDark)
        // Nécessaire sinon bouton s'affiche pas !!!
        self.deleteAccount.translatesAutoresizingMaskIntoConstraints = false

        // ajout bouton vue
        self.view.addSubview(self.deleteAccount)

        // Ajout des contraintes
        NSLayoutConstraint.activate([
            self.deleteAccount.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.deleteAccount.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.tabBarController!.tabBar.frame.height * 4),
            self.deleteAccount.widthAnchor.constraint(equalTo: self.deleteAccount.titleLabel!.widthAnchor, constant: 20)
        ])

        
       
    }

    // Function de changement des paramètres

    @objc func switchLangue(_ sender: UISegmentedControl) {
        print("changement langue")
        param.set(sender.selectedSegmentIndex, forKey: "langue")
    }

    @objc func switchTypeEngagement(_ sender: UISegmentedControl) {
        print("changement type")
        param.set(sender.selectedSegmentIndex, forKey: "type_engagement")
    }

    @IBAction func textFieldChanged(_ sender: UITextField) {
        print("changement durée")
        param.set(sender.text, forKey: "duree_engagement")
    }

    @IBAction func switchSenderData(sender: UISwitch) {
        print("changement suivis")
        param.set(sender.isOn, forKey: "send_data")
    }
}
