//    Copyright (c) 2020, Martin Allusse and Alexandre Baret and Jessy Barritault and Florian
//    Bertonnier and Lisa Fougeron and François Gréau and Thibaud Lambert and Antoine
//    Orgerit and Laurent Rayez
//    All rights reserved.
//    Redistribution and use in source and binary forms, with or without
//    modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright
//      notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//    * Neither the name of the University of California, Berkeley nor the
//      names of its contributors may be used to endorse or promote products
//      derived from this software without specific prior written permission.
//
//    THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
//    EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//    DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
//    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
        self.scrollView.showsVerticalScrollIndicator = false
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
            self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.scrollView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.scrollView.bottomAnchor.constraint(equalTo: secondSeparator.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),

            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.contentView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.checkbox.bottomAnchor)
        ])

        // Texte RGPD
        NSLayoutConstraint.activate([
            self.textRGPD.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.textRGPD.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.textRGPD.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        ])

        // CheckBox
        NSLayoutConstraint.activate([
            self.checkbox.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.checkbox.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.checkbox.topAnchor.constraint(equalTo: self.textRGPD.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL)
        ])
    }

    func boutonsPrevNext(boutonsPrevNext: ButtonsPrevNext, onNext: Bool) {
        self.userPrefs.setPrefs(key: UserPrefs.KEY_FORMULAIRE_CONSENT, value: true)

        // on sauvegarde les données de consentement dans les usersPref temporairement (le temps de faire le formulaire)
        self.saveConsentementForm()
        self.dismiss(animated: true)
    }

    func boutonsPrevNext(boutonsPrevNext: ButtonsPrevNext, onPrevious: Bool) {
        self.userPrefs.setPrefs(key: UserPrefs.KEY_FORMULAIRE_CONSENT, value: false)

        // On supprime les données de consentement du formulaire si elles existent lors d'un refus d'utilisation des données personnelles
        if self.userPrefs.object(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT_DATA) != nil {
            self.userPrefs.removePrefs(key: UserPrefs.KEY_FORMULAIRE_CONSENT_DATA)
        }
        self.dismiss(animated: true)
    }

    /// Sauvegarde les données de consentement de l'utilisation des données personnelles  en local sur le smartphone.
    fileprivate func saveConsentementForm() {
        let now = Date()
        let dict = ["consentement_form": Tools.getTranslate(key: "rgpd_second_content_consentement"), "date_form": now.timeIntervalSince1970, "date_form_str": Tools.convertDateToServerDate(date: now)] as [String: Any]
        UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_FORMULAIRE_CONSENT_DATA, value: dict)
    }
}
