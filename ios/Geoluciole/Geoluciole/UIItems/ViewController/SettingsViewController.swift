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
        
        let zoneId = UIView()
        zoneId.translatesAutoresizingMaskIntoConstraints = false
        let lbId = CustomUILabel()
        lbId.setStyle(style: LabelStyle.TitreSectionBadges)
        lbId.text = "Mon identifiant : "
        lbId.translatesAutoresizingMaskIntoConstraints = false
        let Id = CustomUILabel()
        Id.text = Tools.getIdentifier()
        Id.translatesAutoresizingMaskIntoConstraints = false
        zoneId.addSubview(lbId)
        zoneId.addSubview(Id)
        
        NSLayoutConstraint.activate([
            lbId.topAnchor.constraint(equalTo: zoneId.topAnchor),
            lbId.leftAnchor.constraint(equalTo: zoneId.leftAnchor),
            lbId.widthAnchor.constraint(equalTo: zoneId.widthAnchor),
            lbId.heightAnchor.constraint(equalTo: zoneId.heightAnchor, multiplier: 0.5),
            
            Id.topAnchor.constraint(equalTo: lbId.bottomAnchor),
            Id.leftAnchor.constraint(equalTo: lbId.centerXAnchor),
            Id.rightAnchor.constraint(equalTo: zoneId.rightAnchor),
            Id.heightAnchor.constraint(equalTo: zoneId.heightAnchor, multiplier: 0.5)
        ])
        self.rootView.addSubview(zoneId)
        
        let durationOfEngagementFormView = DurationOfEngagementFormView()
        durationOfEngagementFormView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(durationOfEngagementFormView)

        let languageSelectorView = LanguageSelectorView()
        languageSelectorView.isHidden = false
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
        partnersButton.isHidden = false
        partnersButton.setTitle("VOIR LA LISTE DES PARTENAIRES", for: .normal)
        partnersButton.onClick = { button in
            let partenaire = PartenaireViewController()
            self.present(partenaire, animated: true, completion: nil)
        }
        partnersButton.setStyle(style: .settingLight)
        partnersButton.translatesAutoresizingMaskIntoConstraints = false
        wrapButtons.addSubview(partnersButton)

        let deleteButton = CustomUIButton()
        deleteButton.isHidden = false
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
            zoneId.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            zoneId.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING_HORIZONTAL),
            zoneId.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: Constantes.PAGE_PADDING_HORIZONTAL),
            zoneId.heightAnchor.constraint(equalTo: self.rootView.heightAnchor, multiplier: 0.10),
            durationOfEngagementFormView.topAnchor.constraint(equalTo: zoneId.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL*2),
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
