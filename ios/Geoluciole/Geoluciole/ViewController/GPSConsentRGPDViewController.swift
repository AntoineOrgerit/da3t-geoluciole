//
//  GPSConsentRGPDViewController.swift
//  Geoluciole
//
//  Created by Jessy BARRITAULT on 14/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class GPSConsentRGPDViewController: ParentModalViewController {

    fileprivate var scrollView: UIScrollView!
    fileprivate var contentView: UIView!

    fileprivate var firstSeparator: UIView!
    fileprivate var secondSeparator: UIView!

    fileprivate var titreRGPD: CustomUILabel!
    fileprivate var subtitleRGPD: CustomUILabel!
    fileprivate var textRGPD: CustomUILabel!
    fileprivate var checkbox: CheckBoxFieldView!
    fileprivate var acceptButton: CustomUIButton!
    fileprivate var refuseButton: CustomUIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTitleAndSubtitle()
        self.setupButtons()

        firstSeparator = UIView()
        firstSeparator.backgroundColor = .black
        firstSeparator.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.firstSeparator)

        // ScollView pour le texte
        self.scrollView = UIScrollView()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.scrollView)

        self.contentView = UIView()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.contentView)

        // texte rgpd
        self.textRGPD = CustomUILabel()
        self.textRGPD.numberOfLines = 0
        self.textRGPD.text = Constantes.DESC_PROJET
        self.textRGPD.translatesAutoresizingMaskIntoConstraints = false
        self.textRGPD.font = UIFont.preferredFont(forTextStyle: .body)
        self.textRGPD.textAlignment = .justified
        self.contentView.addSubview(self.textRGPD)

        // Checkbox
        self.checkbox = CheckBoxFieldView()
        self.checkbox.setStyle(style: .tick)
        self.checkbox.setBorderStyle(style: .square)
        self.checkbox.setCheckmarkColor(color: .orange)
        self.checkbox.setCheckedBorderColor(color: .orange)
        self.checkbox.setUncheckedBorderColor(color: .orange)
        self.checkbox.setTitleOption(titleOption: Constantes.TEXTE_VALIDATION_DROIT)
        self.checkbox.translatesAutoresizingMaskIntoConstraints = false
        self.checkbox.onCheckChange = { [weak self] checkboxView in
            guard let strongSelf = self else { return }

            if strongSelf.checkbox.isChecked() {
                strongSelf.acceptButton.setStyle(style: .active)
                strongSelf.refuseButton.setStyle(style: .disabled)
            } else {
                strongSelf.acceptButton.setStyle(style: .disabled)
                strongSelf.refuseButton.setStyle(style: .delete)
            }

            // Autorisation à cliquer sur les boutons
            strongSelf.acceptButton.isUserInteractionEnabled = strongSelf.checkbox.isChecked()
            strongSelf.refuseButton.isUserInteractionEnabled = !strongSelf.checkbox.isChecked()
        }
        self.contentView.addSubview(self.checkbox)

        self.secondSeparator = UIView()
        self.secondSeparator.backgroundColor = .black
        self.secondSeparator.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.secondSeparator)

        self.setupConstraints()
    }

    fileprivate func sendDataCompte() {
        let msg = ElasticSearchAPI.getInstance().generateMessageCompte()
        ElasticSearchAPI.getInstance().postCompte(message: msg)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Permet de resize le content pour permettre le scroll
        scrollView.contentSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height + Constantes.FIELD_SPACING_VERTICAL)
    }

    fileprivate func setupButtons() {

        // Accept Button
        self.acceptButton = CustomUIButton()
        self.acceptButton.setStyle(style: .disabled)
        self.acceptButton.isUserInteractionEnabled = false
        self.acceptButton.setTitle("ACCEPTER", for: .normal)
        self.acceptButton.translatesAutoresizingMaskIntoConstraints = false
        self.acceptButton.onClick = { [weak self] _ in
            guard let strongSelf = self else { return }

            if strongSelf.checkbox.isChecked() {
                strongSelf.sendDataCompte()
                strongSelf.userPrefs.setPrefs(key: UserPrefs.KEY_RGPD_CONSENT, value: true)

                // Avec le consentement, on peut activer la collecte des données
                UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_SEND_DATA, value: true)

                // Demande d'autorisation d'utiliser la localisation et d'envoyer des notifications
                LocationHandler.getInstance().requestLocationAuthorization()
                NotificationHandler.getInstance().requestNotificationAuthorization()
            }

            strongSelf.dismiss(animated: true)
        }
        self.rootView.addSubview(self.acceptButton)

        // button Refuser
        self.refuseButton = CustomUIButton()
        self.refuseButton.setStyle(style: .delete)
        self.refuseButton.setTitle("REFUSER", for: .normal)
        self.refuseButton.translatesAutoresizingMaskIntoConstraints = false
        self.refuseButton.onClick = { [weak self] _ in
            guard let strongSelf = self else { return }

            strongSelf.userPrefs.setPrefs(key: UserPrefs.KEY_RGPD_CONSENT, value: false)
            strongSelf.dismiss(animated: true)
        }
        self.rootView.addSubview(self.refuseButton)
    }

    fileprivate func setupTitleAndSubtitle() {
        // titre
        self.titreRGPD = CustomUILabel()
        self.titreRGPD.text = "Consentement RGPD"
        self.titreRGPD.textColor = .orange
        self.titreRGPD.textAlignment = .center
        self.titreRGPD.translatesAutoresizingMaskIntoConstraints = false
        self.titreRGPD.font = UIFont.preferredFont(forTextStyle: .title1)
        self.rootView.addSubview(self.titreRGPD)

        // sous titre
        self.subtitleRGPD = CustomUILabel()
        self.subtitleRGPD.textAlignment = .center
        self.subtitleRGPD.numberOfLines = 0
        self.subtitleRGPD.translatesAutoresizingMaskIntoConstraints = false
        self.subtitleRGPD.text = Constantes.TEXT_SUB_TITLE_RGPD
        self.subtitleRGPD.textColor = .backgroundDefault
        self.subtitleRGPD.font = UIFont.preferredFont(forTextStyle: .title3)
        self.rootView.addSubview(self.subtitleRGPD)
    }

    fileprivate func setupConstraints() {
        // Titre RGPD
        NSLayoutConstraint.activate([
            self.titreRGPD.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.titreRGPD.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.titreRGPD.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING)
        ])

        // Subtitle RGPD
        NSLayoutConstraint.activate([
            self.subtitleRGPD.topAnchor.constraint(equalTo: self.titreRGPD.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.subtitleRGPD.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.subtitleRGPD.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING)
        ])

        // FirstSeparator
        NSLayoutConstraint.activate([
            self.firstSeparator.widthAnchor.constraint(equalTo: self.rootView.widthAnchor, multiplier: 0.5),
            self.firstSeparator.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
            self.firstSeparator.heightAnchor.constraint(equalToConstant: 1),
            self.firstSeparator.topAnchor.constraint(equalTo: self.subtitleRGPD.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL)
        ])

        // Boutons
        NSLayoutConstraint.activate([
            self.acceptButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            self.acceptButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.acceptButton.widthAnchor.constraint(equalTo: self.rootView.widthAnchor, multiplier: 0.45),

            self.refuseButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            self.refuseButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.refuseButton.widthAnchor.constraint(equalTo: self.rootView.widthAnchor, multiplier: 0.45),
        ])

        // SecondSeparator
        NSLayoutConstraint.activate([
            self.secondSeparator.widthAnchor.constraint(equalTo: self.rootView.widthAnchor, multiplier: 0.5),
            self.secondSeparator.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
            self.secondSeparator.heightAnchor.constraint(equalToConstant: 1),
            self.secondSeparator.bottomAnchor.constraint(equalTo: self.refuseButton.topAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL)
        ])

        // Constraints ScrollView
        NSLayoutConstraint.activate([

            self.scrollView.topAnchor.constraint(equalTo: self.firstSeparator.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: secondSeparator.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),

            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.rootView.widthAnchor),
            self.contentView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.checkbox.bottomAnchor)
        ])

        // Texte RGPD
        NSLayoutConstraint.activate([
            self.textRGPD.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.textRGPD.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.textRGPD.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Constantes.FIELD_SPACING_VERTICAL)
        ])

        // CheckBox
        NSLayoutConstraint.activate([
            self.checkbox.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.checkbox.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.checkbox.topAnchor.constraint(equalTo: self.textRGPD.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL)
        ])
    }
}
