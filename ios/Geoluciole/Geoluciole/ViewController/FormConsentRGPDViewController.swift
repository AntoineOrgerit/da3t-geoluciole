//
//  FormConsentRGPDViewController.swift
//  Geoluciole
//
//  Created by Jessy BARRITAULT on 15/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//


import Foundation
import UIKit

class FormConsentRGPDViewController: ParentModalViewController, ButtonsPrevNextDelegate {

    fileprivate var scrollView: UIScrollView!
    fileprivate var contentView: UIView!

    fileprivate var firstSeparator: UIView!
    fileprivate var secondSeparator: UIView!

    fileprivate var titreRGPD: CustomUILabel!
    fileprivate var subtitleRGPD: CustomUILabel!
    fileprivate var textRGPD: CustomUILabel!
    fileprivate var checkbox: CheckBoxFieldView!
    fileprivate var buttons: ButtonsPrevNext!

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
        let rgpdContent = Tools.getTranslate(key: "rgpd_second_content_1_line") + "\n\n" + Tools.getTranslate(key: "rgpd_second_content_2_line") + "\n\n" + Tools.getTranslate(key: "rgpd_second_content_3_line") + "\n\n" + Tools.getTranslate(key: "rgpd_second_content_4_line") + "\n\n" + Tools.getTranslate(key: "rgpd_second_content_5_line") + "\n\n" +
            Tools.getTranslate(key: "rgpd_second_content_6_line") + "\n\n" +
            Tools.getTranslate(key: "rgpd_second_content_7_line")
        self.textRGPD.text = rgpdContent
        self.textRGPD.translatesAutoresizingMaskIntoConstraints = false
        self.textRGPD.setStyle(style: .bodyRegular)
        self.textRGPD.textAlignment = .justified
        self.contentView.addSubview(self.textRGPD)

        // Checkbox
        self.checkbox = CheckBoxFieldView()
        self.checkbox.setStyle(style: .tick)
        self.checkbox.setBorderStyle(style: .square)
        self.checkbox.setCheckmarkColor(color: .orange)
        self.checkbox.setCheckedBorderColor(color: .orange)
        self.checkbox.setUncheckedBorderColor(color: .orange)
        self.checkbox.setTitleOption(titleOption: Tools.getTranslate(key: "rgpd_second_content_consentement"))
        self.checkbox.translatesAutoresizingMaskIntoConstraints = false
        self.checkbox.onCheckChange = { [weak self] checkboxView in
            guard let strongSelf = self else { return }

            if strongSelf.checkbox.isChecked() {
                strongSelf.buttons.setDisabled(button: .previous)
                strongSelf.buttons.setEnabled(button: .next)
            } else {
                strongSelf.buttons.setDisabled(button: .next)
                strongSelf.buttons.setEnabled(button: .previous)
            }
        }
        self.contentView.addSubview(self.checkbox)

        self.secondSeparator = UIView()
        self.secondSeparator.backgroundColor = .black
        self.secondSeparator.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.secondSeparator)

        self.setupConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Permet de resize le content pour permettre le scroll
        self.scrollView.contentSize = CGSize(width: self.contentView.bounds.width, height: contentView.bounds.height + Constantes.FIELD_SPACING_VERTICAL)
    }

    fileprivate func setupButtons() {
        self.buttons = FabricCustomButton.createButton(type: .refuseAccept)
        self.buttons.delegate = self
        self.buttons.translatesAutoresizingMaskIntoConstraints = false
        self.buttons.setDisabled(button: .next)
        self.rootView.addSubview(self.buttons)
    }

    fileprivate func setupTitleAndSubtitle() {
        // titre
        self.titreRGPD = CustomUILabel()
        self.titreRGPD.text = Tools.getTranslate(key: "rgpd_title_primary")
        self.titreRGPD.textColor = .orange
        self.titreRGPD.textAlignment = .center
        self.titreRGPD.translatesAutoresizingMaskIntoConstraints = false
        self.titreRGPD.setStyle(style: .titleBold)
        self.rootView.addSubview(self.titreRGPD)

        // sous titre
        self.subtitleRGPD = CustomUILabel()
        self.subtitleRGPD.textAlignment = .center
        self.subtitleRGPD.numberOfLines = 0
        self.subtitleRGPD.translatesAutoresizingMaskIntoConstraints = false
        self.subtitleRGPD.text = Tools.getTranslate(key: "rgpd_title_project")
        self.subtitleRGPD.textColor = .backgroundDefault
        self.subtitleRGPD.setStyle(style: .subtitleBold)
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
            self.buttons.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            self.buttons.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.buttons.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING)
        ])

        // SecondSeparator
        NSLayoutConstraint.activate([
            self.secondSeparator.widthAnchor.constraint(equalTo: self.rootView.widthAnchor, multiplier: 0.5),
            self.secondSeparator.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor),
            self.secondSeparator.heightAnchor.constraint(equalToConstant: 1),
            self.secondSeparator.bottomAnchor.constraint(equalTo: self.buttons.topAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL)
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

    fileprivate func sendDataCompte() {
        // Construction d'un dictionnaire contenant les données à envoyer
        var compte = [[String: Any]]()

        let now = Date()
        // TODO: METTRE LES BONNES DATA
        let dict = ["consentement_form": NSLocalizedString("rgpd_second_content_consentement", comment: ""), "date_form": now.timeIntervalSince1970, "nom": "test2", "prenom": "test2", "mail": "mail2@gmail.com", "date_form_str": Tools.convertDateToServerDate(date: now)] as [String: Any]
        compte.append(dict)

        let msg = ElasticSearchAPI.getInstance().generateMessage(content: compte, needBulk: true)
        ElasticSearchAPI.getInstance().postCompte(message: msg)
    }

    func boutonsPrevNext(boutonsPrevNext: ButtonsPrevNext, onNext: Bool) {
        self.sendDataCompte()
        self.userPrefs.setPrefs(key: UserPrefs.KEY_FORMULAIRE_CONSENT, value: true)

        self.dismiss(animated: true)
    }

    func boutonsPrevNext(boutonsPrevNext: ButtonsPrevNext, onPrevious: Bool) {
        self.userPrefs.setPrefs(key: UserPrefs.KEY_FORMULAIRE_CONSENT, value: false)
        self.dismiss(animated: true)
    }
}
