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
        languageSelectorView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(languageSelectorView)

        let wrapButtons = UIView()
        wrapButtons.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(wrapButtons)

        let cguButton = CustomUIButton()
        cguButton.setTitle("CONSULTER LES CGU", for: .normal)
        cguButton.onClick = { button in
            let cguController = CGUViewController()
            self.present(cguController, animated: true, completion: nil)
        }
        cguButton.setStyle(color: .CGU)
        cguButton.translatesAutoresizingMaskIntoConstraints = false
        wrapButtons.addSubview(cguButton)

        let partnersButton = CustomUIButton()
        partnersButton.setTitle("VOIR LA LISTE DES PARTENAIRES", for: .normal)
        partnersButton.onClick = { button in
            print("Clic sur les partenaires")
            let partenaire = PartenaireViewController()
            self.present(partenaire, animated: true, completion: nil)
        }
        partnersButton.setStyle(color: .partner)
        partnersButton.translatesAutoresizingMaskIntoConstraints = false
        wrapButtons.addSubview(partnersButton)

        let deleteButton = CustomUIButton()
        deleteButton.setTitle("RÉVOQUER MON CONSENTEMENT", for: .normal)
        deleteButton.onClick = { button in
            print("Clic sur le consentement")
        }
        deleteButton.setStyle(color: .delete)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        wrapButtons.addSubview(deleteButton)

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

            cguButton.topAnchor.constraint(equalTo: wrapButtons.topAnchor),
            cguButton.centerXAnchor.constraint(equalTo: wrapButtons.centerXAnchor),
            cguButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
            cguButton.widthAnchor.constraint(equalTo: deleteButton.widthAnchor),

            partnersButton.topAnchor.constraint(equalTo: cguButton.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            partnersButton.centerXAnchor.constraint(equalTo: wrapButtons.centerXAnchor),
            partnersButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
            partnersButton.widthAnchor.constraint(equalTo: deleteButton.widthAnchor),

            deleteButton.topAnchor.constraint(equalTo: partnersButton.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            deleteButton.centerXAnchor.constraint(equalTo: wrapButtons.centerXAnchor),
            deleteButton.heightAnchor.constraint(equalTo: deleteButton.titleLabel!.heightAnchor, constant: 40),
            deleteButton.widthAnchor.constraint(equalTo: deleteButton.titleLabel!.widthAnchor, constant: 40)
        ])
    }
}
