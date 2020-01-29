//
//  SettingsViewController.swift
//  Geoluciole
//
//  Created by Thibaud LAMBERT on 09/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class SettingsViewController: ParentViewController {

    fileprivate var scrollView: UIScrollView!
    fileprivate var contentView: UIView!
    fileprivate var deleteButton: CustomUIButton!
    fileprivate var sendDataManually: CustomUIButton!
    
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
        languageSelectorView.onChange = {
            func close(action: UIAlertAction) {
                exit(0)
            }

            let alert = UIAlertController(title: Tools.getTranslate(key: "alert_close_app_title"), message: "\(Tools.getTranslate(key: "alert_close_app_explanation"))", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: Tools.getTranslate(key: "sendMail"), style: .destructive, handler: close))

            self.present(alert, animated: true, completion: nil)

        }
        self.contentView.addSubview(languageSelectorView)

        let wrapButtons = UIView()
        wrapButtons.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(wrapButtons)

        let cguButton = CustomUIButton()
        cguButton.setTitle(Tools.getTranslate(key: "licence_agreement"), for: .normal)
        cguButton.onClick = { button in
            let cguController = CGUViewController()
            cguController.modalPresentationStyle = .fullScreen
            self.present(cguController, animated: true, completion: nil)
        }
        cguButton.setStyle(style: .settingLight)
        cguButton.translatesAutoresizingMaskIntoConstraints = false
        wrapButtons.addSubview(cguButton)

        let partnersButton = CustomUIButton()
        partnersButton.setTitle(Tools.getTranslate(key: "partners"), for: .normal)
        partnersButton.onClick = { button in
            let partners = PartnersViewController()
            partners.modalPresentationStyle = .fullScreen
            self.present(partners, animated: true, completion: nil)
        }
        partnersButton.setStyle(style: .settingLight)
        partnersButton.translatesAutoresizingMaskIntoConstraints = false
        wrapButtons.addSubview(partnersButton)

        self.deleteButton = CustomUIButton()
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
        wrapButtons.addSubview(self.deleteButton)

        self.sendDataManually = CustomUIButton()
        self.sendDataManually.setTitle(Tools.getTranslate(key: "send_data"), for: .normal)
        self.sendDataManually.onClick = { [weak self] _ in
            guard let strongSelf = self else { return }

            let queue = DispatchQueue(label: "SendData", qos: .background)

            queue.async {
                CustomTimer.getInstance().sendPostLocationElasticSearch(viewController: strongSelf)
            }

        }
        self.sendDataManually.setStyle(style: .settingDark)
        self.sendDataManually.translatesAutoresizingMaskIntoConstraints = false
        wrapButtons.addSubview(self.sendDataManually)

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
            wrapButtons.bottomAnchor.constraint(equalTo: self.sendDataManually.bottomAnchor),

            partnersButton.topAnchor.constraint(equalTo: wrapButtons.topAnchor),
            partnersButton.rightAnchor.constraint(equalTo: wrapButtons.rightAnchor),
            partnersButton.leftAnchor.constraint(equalTo: wrapButtons.leftAnchor),

            cguButton.topAnchor.constraint(equalTo: partnersButton.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            cguButton.widthAnchor.constraint(equalTo: wrapButtons.widthAnchor),
            cguButton.leftAnchor.constraint(equalTo: wrapButtons.leftAnchor),

            self.deleteButton.topAnchor.constraint(equalTo: cguButton.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.deleteButton.widthAnchor.constraint(equalTo: wrapButtons.widthAnchor),
            self.deleteButton.leftAnchor.constraint(equalTo: wrapButtons.leftAnchor),

            self.sendDataManually.topAnchor.constraint(equalTo: self.deleteButton.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.sendDataManually.rightAnchor.constraint(equalTo: wrapButtons.rightAnchor),
            self.sendDataManually.leftAnchor.constraint(equalTo: wrapButtons.leftAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Permet de resize le content pour permettre le scroll
        scrollView.contentSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height + Constantes.FIELD_SPACING_VERTICAL)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_RGPD_CONSENT) {
            self.deleteButton.setTitle(Tools.getTranslate(key: "revoke_consent"), for: .normal)
            self.deleteButton.setStyle(style: .settingLight)
            self.deleteButton.onClick = { button in
                self.openRevokConsent()
            }
            self.sendDataManually.isHidden = false
        } else {
            self.deleteButton.setTitle(Tools.getTranslate(key: "give_consent"), for: .normal)
            self.deleteButton.setStyle(style: .settingDark)
            self.deleteButton.onClick = { button in
                let rgpdController = GPSConsentRGPDViewController()
                rgpdController.modalPresentationStyle = .fullScreen
                self.present(rgpdController, animated: true)
            }
            self.sendDataManually.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func openRevokConsent() {
        let message = Tools.getTranslate(key: "revoke_text_1") + "\(Constantes.REVOQ_CONSENT_MAIL)"
        let alert = UIAlertController(title: Tools.getTranslate(key: "revoke_title"), message: message, preferredStyle: .alert)
        if MFMailComposeViewController.canSendMail() {
            alert.title! += Tools.getTranslate(key: "revoke_text_2")
            alert.addAction(UIAlertAction(title: Tools.getTranslate(key: "sendMail"), style: .destructive, handler: openMailApp))
        }
        alert.addAction(UIAlertAction(title: Tools.getTranslate(key: "copy"), style: .default, handler: saveToClipBoard))
        alert.addAction(UIAlertAction(title: Tools.getTranslate(key: "back"), style: .default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    func saveToClipBoard(action: UIAlertAction) {
        UIPasteboard.general.string = userPrefs.string(forKey: UserPrefs.KEY_IDENTIFIER)
        self.rootView.makeToast(Tools.getTranslate(key: "toast_copy_id"), duration: 2, position: .bottom)
    }

    func openMailApp(action: UIAlertAction) {
        let email = Constantes.REVOQ_CONSENT_MAIL

        let identifiant = userPrefs.string(forKey: UserPrefs.KEY_IDENTIFIER)
        // TODO: I18N
        let stringURL = "mailto:\(email)?subject=Revoquer%20mon%20consentement&body=\(identifiant)%20demande%20la%20suppression%20de%20ses%20donn%C3%A9es"
        if let url = URL(string: stringURL) {

            // L'application est dispo qu'à partir de iOS 10 donc pas besoin du else
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            }
        }
    }
}
