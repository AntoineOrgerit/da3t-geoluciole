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

    fileprivate var scrollView: UIScrollView!
    fileprivate var contentView: UIView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView = UIScrollView()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.scrollView)

        self.contentView = UIView()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.contentView)

        let identifierView = IdentifierView()
        identifierView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(identifierView)

        let durationOfEngagementFormView = DurationOfEngagementFormView()
        durationOfEngagementFormView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(durationOfEngagementFormView)

        let languageSelectorView = LanguageSelectorView()
        languageSelectorView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(languageSelectorView)

        let wrapButtons = UIView()
        wrapButtons.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(wrapButtons)

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
        partnersButton.setTitle("VOIR LA LISTE DES PARTENAIRES", for: .normal)
        partnersButton.onClick = { button in
            let partenaire = PartenaireViewController()
            self.present(partenaire, animated: true, completion: nil)
        }
        partnersButton.setStyle(style: .settingLight)
        partnersButton.translatesAutoresizingMaskIntoConstraints = false
        wrapButtons.addSubview(partnersButton)

        let deleteButton = CustomUIButton()
        deleteButton.setTitle("RÉVOQUER MON CONSENTEMENT", for: .normal)
        deleteButton.onClick = { button in

        }
        deleteButton.setStyle(style: .settingLight)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        wrapButtons.addSubview(deleteButton)

        let sendDataManually = CustomUIButton()
        sendDataManually.setTitle("ENVOYER MES DONNÉES", for: .normal)
        sendDataManually.onClick = { button in
            CustomTimer.getInstance().sendPostLocationElasticSearch()
        }
        sendDataManually.setStyle(style: .settingDark)
        sendDataManually.translatesAutoresizingMaskIntoConstraints = false
        wrapButtons.addSubview(sendDataManually)

        // Constraints ScrollView
        NSLayoutConstraint.activate([

            self.scrollView.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor),

            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.rootView.widthAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: wrapButtons.bottomAnchor)
        ])

        // Constraints IdentifierView
        NSLayoutConstraint.activate([
            identifierView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            identifierView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constantes.PAGE_PADDING),
            identifierView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constantes.PAGE_PADDING)
        ])

        // Constraints DurationOfEngagementFormView
        NSLayoutConstraint.activate([
            durationOfEngagementFormView.topAnchor.constraint(equalTo: identifierView.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            durationOfEngagementFormView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constantes.PAGE_PADDING),
            durationOfEngagementFormView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constantes.PAGE_PADDING)
        ])

        // Constraints LanguageSelectorView
        NSLayoutConstraint.activate([
            languageSelectorView.topAnchor.constraint(equalTo: durationOfEngagementFormView.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            languageSelectorView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constantes.PAGE_PADDING),
            languageSelectorView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constantes.PAGE_PADDING)
        ])

        // Constraints WrapButtons
        NSLayoutConstraint.activate([
            wrapButtons.topAnchor.constraint(equalTo: languageSelectorView.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL * 2),
            wrapButtons.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constantes.PAGE_PADDING),
            wrapButtons.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            wrapButtons.bottomAnchor.constraint(equalTo: sendDataManually.bottomAnchor),

            partnersButton.topAnchor.constraint(equalTo: wrapButtons.topAnchor),
            partnersButton.rightAnchor.constraint(equalTo: wrapButtons.rightAnchor),
            partnersButton.leftAnchor.constraint(equalTo: wrapButtons.leftAnchor),

            cguButton.topAnchor.constraint(equalTo: partnersButton.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            cguButton.widthAnchor.constraint(equalTo: wrapButtons.widthAnchor),
            cguButton.leftAnchor.constraint(equalTo: wrapButtons.leftAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: cguButton.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            deleteButton.widthAnchor.constraint(equalTo: wrapButtons.widthAnchor),
            deleteButton.leftAnchor.constraint(equalTo: wrapButtons.leftAnchor),

            sendDataManually.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            sendDataManually.rightAnchor.constraint(equalTo: wrapButtons.rightAnchor),
            sendDataManually.leftAnchor.constraint(equalTo: wrapButtons.leftAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Permet de resize le content pour permettre le scroll
        scrollView.contentSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height + Constantes.FIELD_SPACING_VERTICAL)
    }
}
