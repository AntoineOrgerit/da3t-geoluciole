//
//  GPSConsentRGPDViewController.swift
//  Geoluciole
//
//  Created by Jessy BARRITAULT on 14/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class GPSConsentRGPDViewController: ParentViewController {

    fileprivate var textRGPD: UITextView!
    fileprivate var titreRGPD: UILabel!
    fileprivate var subtitleRGPD: UILabel!
    fileprivate var button: CustomUIButton!
    fileprivate var checkbox: CheckBoxFieldView!
    fileprivate var consentLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // On doit mettre rootView en blanc et je sais pas pourquoi
        self.rootView.backgroundColor = .white
        
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
        self.subtitleRGPD.numberOfLines = 0
        self.subtitleRGPD.translatesAutoresizingMaskIntoConstraints = false
        self.subtitleRGPD.text = Constantes.TEXT_SUB_TITLE_RGPD
        self.subtitleRGPD.textColor = .backgroundDefault
        self.subtitleRGPD.font = UIFont.preferredFont(forTextStyle: .title3)
        self.rootView.addSubview(self.subtitleRGPD)

        // texte rgpd
        self.textRGPD = UITextView()
        self.textRGPD.text = Constantes.TEXT_RGPD
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

        // button
        self.button = CustomUIButton()
        self.button.layer.cornerRadius = 10
        self.button.backgroundColor = .lightGray
        self.button.isUserInteractionEnabled = false
        self.button.setTitle("Valider", for: .normal)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.onClick = { [weak self] _ in
            guard let strongSelf = self else { return }
            if strongSelf.checkbox.isChecked() {
                strongSelf.sendDataCompte()
                strongSelf.userPrefs.setPrefs(key: UserPrefs.KEY_RGPD_CONSENT, value: true)
            }
            strongSelf.dismiss(animated: true, completion: nil)
        }
        self.rootView.addSubview(self.button)
        
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
                strongSelf.button.isUserInteractionEnabled = true
                strongSelf.button.backgroundColor = .backgroundDefault
            } else {
                strongSelf.button.isUserInteractionEnabled = false
                strongSelf.button.backgroundColor = .lightGray
            }
            // Faire le save prefs dans methode click du bouton
            // Si la checkbox est cochée alors activer le bouton et le mettre en orange
            // Si la checkbox est décochée alors désactiver le bouton et le remettre en gris
        }
        self.rootView.addSubview(self.checkbox)
        
        // Masquer un bout en bas de l'écran
        let subStatusBarView  = UIView()
        subStatusBarView.backgroundColor = .white
        subStatusBarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(subStatusBarView)
        
        NSLayoutConstraint.activate([
            subStatusBarView.topAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor),
            subStatusBarView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.bottomAnchor),
            subStatusBarView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            subStatusBarView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
        
        // Titre RGPD
        NSLayoutConstraint.activate([
            self.titreRGPD.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.titreRGPD.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            self.titreRGPD.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL)
        ])
        
        // Subtitle RGPD
        NSLayoutConstraint.activate([
            self.subtitleRGPD.topAnchor.constraint(equalTo: self.titreRGPD.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.subtitleRGPD.centerXAnchor.constraint(equalTo: self.rootView.centerXAnchor)
        ])
        
        // Bouton Accepter
        NSLayoutConstraint.activate([
            self.button.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            self.button.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            self.button.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL)
        ])
        
        // CheckBox
        NSLayoutConstraint.activate([
            self.checkbox.bottomAnchor.constraint(equalTo: self.button.topAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            self.checkbox.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            self.checkbox.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL)
        ])
        
        // Texte RGPD
        NSLayoutConstraint.activate([
            self.textRGPD.bottomAnchor.constraint(equalTo: self.checkbox.topAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            self.textRGPD.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            self.textRGPD.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            self.textRGPD.topAnchor.constraint(equalTo: self.subtitleRGPD.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL)
        ])
    }

    func sendDataCompte(){
        let msg = ElasticSearchAPI.getInstance().generateMessageCompte()
        ElasticSearchAPI.getInstance().postCompte(message: msg)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
