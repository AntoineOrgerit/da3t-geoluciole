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

    fileprivate var titreRGPD: UILabel!
    fileprivate var subtitleRGPD: UILabel!
    fileprivate var textRGPD: UITextView!
    fileprivate var checkbox: CheckBoxFieldView!
    fileprivate var acceptButton: CustomUIButton!
    fileprivate var refuseButton: CustomUIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // titre
        self.titreRGPD = UILabel()
        self.titreRGPD.text = "Consentement RGPD"
        self.titreRGPD.textColor = .orange
        self.titreRGPD.textAlignment = .center
        self.titreRGPD.translatesAutoresizingMaskIntoConstraints = false
        self.titreRGPD.font = UIFont.preferredFont(forTextStyle: .title1)
        self.rootView.addSubview(self.titreRGPD)

        // sous titre
        self.subtitleRGPD = UILabel()
        self.subtitleRGPD.textAlignment = .center
        self.subtitleRGPD.numberOfLines = 0
        self.subtitleRGPD.translatesAutoresizingMaskIntoConstraints = false
        self.subtitleRGPD.text = Constantes.TEXT_SUB_TITLE_RGPD
        self.subtitleRGPD.textColor = .backgroundDefault
        self.subtitleRGPD.font = UIFont.preferredFont(forTextStyle: .title3)
        self.rootView.addSubview(self.subtitleRGPD)

        // texte rgpd
        self.textRGPD = UITextView()
        self.textRGPD.text = Constantes.DESC_PROJET
        self.textRGPD.isUserInteractionEnabled = true
        self.textRGPD.isScrollEnabled = true
        self.textRGPD.showsVerticalScrollIndicator = true
        self.textRGPD.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.textRGPD.translatesAutoresizingMaskIntoConstraints = false
        self.textRGPD.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 500), for: NSLayoutConstraint.Axis.vertical)
        self.textRGPD.isEditable = false
        self.textRGPD.textColor = .clear
        self.textRGPD.backgroundColor = .clear
        self.textRGPD.font = UIFont(name: self.textRGPD.font!.fontName, size: 18)
        self.textRGPD.textColor = .black
        self.textRGPD.textAlignment = .justified
        self.rootView.addSubview(self.textRGPD)

        // button Accpeter
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
            } else {
                strongSelf.acceptButton.setStyle(style: .disabled)
            }
            
            // Autorisation à cliquer sur les boutons
            strongSelf.acceptButton.isUserInteractionEnabled = strongSelf.checkbox.isChecked()
            strongSelf.refuseButton.isUserInteractionEnabled = !strongSelf.checkbox.isChecked()
        }
        self.rootView.addSubview(self.checkbox)

        // Titre RGPD
        NSLayoutConstraint.activate([
            self.titreRGPD.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.titreRGPD.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            self.titreRGPD.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL)
        ])

        // Subtitle RGPD
        NSLayoutConstraint.activate([
            self.subtitleRGPD.topAnchor.constraint(equalTo: self.titreRGPD.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.subtitleRGPD.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.subtitleRGPD.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING)
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

        // CheckBox
        NSLayoutConstraint.activate([
            self.checkbox.bottomAnchor.constraint(equalTo: self.refuseButton.topAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            self.checkbox.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.checkbox.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING)
        ])

        // Texte RGPD
        NSLayoutConstraint.activate([
            self.textRGPD.bottomAnchor.constraint(equalTo: self.checkbox.topAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            self.textRGPD.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.textRGPD.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.textRGPD.topAnchor.constraint(equalTo: self.subtitleRGPD.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL)
        ])
    }

    func sendDataCompte() {
        let msg = ElasticSearchAPI.getInstance().generateMessageCompte()
        ElasticSearchAPI.getInstance().postCompte(message: msg)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
