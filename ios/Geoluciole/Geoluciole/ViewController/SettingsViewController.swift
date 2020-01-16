//
//  SettingsViewController.swift
//  Geoluciole
//
//  Created by local192 on 09/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: ParentViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let durationOfEngagementFormView = DurationOfEngagementFormView()
        durationOfEngagementFormView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(durationOfEngagementFormView)

        let languageSelectorView = LanguageSelectorView()
        languageSelectorView.isHidden = true
        languageSelectorView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(languageSelectorView)

        let wrapButtons = UIView()
        wrapButtons.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(wrapButtons)

        let cguButton = CustomUIButton()
        cguButton.setTitle("CONSULTER LES CGU", for: .normal)
        cguButton.onClick = { button in
            let cguController = CGUViewController()
            cguController.modalPresentationStyle = .fullScreen
            self.present(cguController, animated: true, completion: nil)
        }
        cguButton.setStyle(style: .settingLight)
        cguButton.translatesAutoresizingMaskIntoConstraints = false
        wrapButtons.addSubview(cguButton)

        let partnersButton = CustomUIButton()
        partnersButton.isHidden = true
        partnersButton.setTitle("VOIR LA LISTE DES PARTENAIRES", for: .normal)
        partnersButton.onClick = { button in
            
        }
        partnersButton.setStyle(style: .settingLight)
        partnersButton.translatesAutoresizingMaskIntoConstraints = false
        wrapButtons.addSubview(partnersButton)

        let deleteButton = CustomUIButton()
        deleteButton.isHidden = true
        deleteButton.setTitle("RÉVOQUER MON CONSENTEMENT", for: .normal)
        deleteButton.onClick = { button in
            
        }
        deleteButton.setStyle(style: .settingDark)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        wrapButtons.addSubview(deleteButton)
        
        let sendDataManually = CustomUIButton()
        sendDataManually.setTitle("ENVOYER MES DONNÉES", for: .normal)
        sendDataManually.onClick = { button in
            CustomTimer.getInstance().sendPostLocationElasticSearch()
        }
        sendDataManually.setStyle(style: .settingLight)
        sendDataManually.translatesAutoresizingMaskIntoConstraints = false
        wrapButtons.addSubview(sendDataManually)

        // Constraints DurationOfEngagementFormView
        NSLayoutConstraint.activate([
            durationOfEngagementFormView.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            durationOfEngagementFormView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING_HORIZONTAL),
            durationOfEngagementFormView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING_HORIZONTAL)
        ])

        // Constraints LanguageSelectorView
        NSLayoutConstraint.activate([
            languageSelectorView.topAnchor.constraint(equalTo: durationOfEngagementFormView.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            languageSelectorView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING_HORIZONTAL),
            languageSelectorView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING_HORIZONTAL)
        ])

        // Constraints WrapButtons
        NSLayoutConstraint.activate([
            wrapButtons.topAnchor.constraint(equalTo: languageSelectorView.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            wrapButtons.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            wrapButtons.rightAnchor.constraint(equalTo: self.rootView.rightAnchor),
            wrapButtons.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor),
            
            sendDataManually.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            sendDataManually.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            sendDataManually.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            
            deleteButton.bottomAnchor.constraint(equalTo: sendDataManually.topAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            deleteButton.widthAnchor.constraint(equalTo: self.rootView.widthAnchor, multiplier: 0.45),
            deleteButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            
            cguButton.bottomAnchor.constraint(equalTo: sendDataManually.topAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            cguButton.widthAnchor.constraint(equalTo: self.rootView.widthAnchor, multiplier: 0.45),
            cguButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            
            partnersButton.bottomAnchor.constraint(equalTo: cguButton.topAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            partnersButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            partnersButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL)
        ])
    }
}
