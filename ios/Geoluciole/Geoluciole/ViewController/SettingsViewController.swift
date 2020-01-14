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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let send = self.userPrefs.bool(forKey: "send_data")
        switchDataParam.setOn(send, animated: true)

        // Modification style bouton


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let send = self.userPrefs.bool(forKey: "send_data")
        switchDataParam.setOn(send, animated: true)
        self.label.delegate = self
        label.text = self.userPrefs.string(forKey: UserPrefs.KEY_DUREE_ENGAGEMENT)
        type_engagement.selectedSegmentIndex = self.userPrefs.int(forKey: UserPrefs.KEY_TYPE_ENGAGEMENT)
        type_engagement.addTarget(self, action: #selector(SettingsViewController.switchTypeEngagement), for: .valueChanged)

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
    @objc fileprivate func switchTypeEngagement() {
        print("Changement type engagement")
        self.userPrefs.setPrefs(key: UserPrefs.KEY_TYPE_ENGAGEMENT, value: self.type_engagement.selectedSegmentIndex)
    }

    @objc fileprivate func textFieldChanged() {
        print("Changement durée")
        self.userPrefs.setPrefs(key: UserPrefs.KEY_DUREE_ENGAGEMENT, value: self.label.text!)
    }
}
