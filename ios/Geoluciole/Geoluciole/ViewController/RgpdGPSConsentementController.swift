//
//  RgpdGPSConsentementController.swift
//  Geoluciole
//
//  Created by Jessy BARRITAULT on 14/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class RgpdGPSConsentementController: UIViewController {

    fileprivate var textRGPD: UITextView!
    fileprivate var titreRGPD: UILabel!
    fileprivate var subtitleRGPD: UILabel!
    fileprivate var button: CustomUIButton!
    fileprivate var checkbox: CheckBoxView!
    fileprivate var consentLabel: UITextView!


    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //self.view.removeAllViews()
        // titre
        self.titreRGPD = UILabel()
        self.titreRGPD.text = Constantes.TEXTE_TITLE_RGPD
        self.titreRGPD.textColor = UIColor.orange
        self.titreRGPD.translatesAutoresizingMaskIntoConstraints = false
        self.titreRGPD.font = UIFont.preferredFont(forTextStyle: .title1)
        self.view.addSubview(self.titreRGPD)

        // sous titre
        self.subtitleRGPD = UILabel()
        self.subtitleRGPD.translatesAutoresizingMaskIntoConstraints = false
        self.subtitleRGPD.text = Constantes.TEXTE_SOUS_TITLE_RGPD
        self.subtitleRGPD.textColor = UIColor.backgroundDefault
        self.subtitleRGPD.font = UIFont.preferredFont(forTextStyle: .title2)
        self.view.addSubview(self.subtitleRGPD)



        // texte rgpd

        self.textRGPD = UITextView()
        self.textRGPD.text = Constantes.TEXTE_RGPD
        self.textRGPD.isUserInteractionEnabled = true
        self.textRGPD.isScrollEnabled = true
        self.textRGPD.showsVerticalScrollIndicator = true
        self.textRGPD.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.textRGPD.translatesAutoresizingMaskIntoConstraints = false
        self.textRGPD.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 500), for: NSLayoutConstraint.Axis.vertical)
        self.textRGPD.isEditable = false
        self.textRGPD.textColor = UIColor.clear
        self.textRGPD.backgroundColor = UIColor.clear
        self.textRGPD.font = UIFont(name: self.textRGPD.font!.fontName, size: 18)
        self.textRGPD.textColor = UIColor.black
        self.textRGPD.textAlignment = .justified


        self.view.addSubview(self.textRGPD)
        

        // button
        self.button = CustomUIButton()

        self.button.backgroundColor = UIColor.orange
        self.button.setTitle("Valider", for: .normal)
        
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.onClick = { _ in
            self.dismiss(animated: true, completion: nil)
        }
        self.view.addSubview(self.button)

        
        // checkbox
        
        self.checkbox = CheckBoxView()
        self.checkbox.style = .tick
        self.checkbox.borderStyle = .square
        self.checkbox.backgroundColor = .backgroundDefault
        self.checkbox.checkmarkColor = .white
        self.checkbox.tintColor = .backgroundDefault
        
        self.checkbox.translatesAutoresizingMaskIntoConstraints = false
        self.checkbox.addTarget(self, action: #selector(onCheckBoxValueChange(_:)), for: .valueChanged)
        self.view.addSubview(self.checkbox)

        self.consentLabel = UITextView()
        self.consentLabel.text = Constantes.TEXTE_VALIDATION_DROIT
        
        self.consentLabel.isUserInteractionEnabled = false
        self.consentLabel.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.consentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(consentLabel)
        

        // gestion dark theme
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                self.textRGPD.textColor = UIColor.white
                self.view.backgroundColor = UIColor.black
                self.consentLabel.textColor = UIColor.white
            } else {
                self.textRGPD.textColor = UIColor.black
                self.view.backgroundColor = UIColor.white
                self.consentLabel.textColor = UIColor.black
            }
        }

        // Liste des Contraintes

        // titre
        let cons_titre_top = NSLayoutConstraint(item: self.titreRGPD!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 100)

        let cons_titre_left = NSLayoutConstraint(item: self.titreRGPD!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 10)

        // subtitle
        let cons_subtitle_top = NSLayoutConstraint(item: self.subtitleRGPD!, attribute: .top, relatedBy: .equal, toItem: self.titreRGPD, attribute: .bottom, multiplier: 1, constant: 20)

        let cons_subtitle_left = NSLayoutConstraint(item: self.subtitleRGPD!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 10)

        // texte rgpd

        let cons_text_top = NSLayoutConstraint(item: self.textRGPD!, attribute: .top, relatedBy: .equal, toItem: self.subtitleRGPD, attribute: .bottom, multiplier: 1, constant: 20)

        let cons_text_left = NSLayoutConstraint(item: self.textRGPD!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 10)
        let cons_text_width = self.textRGPD.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20)

        let cons_text_height = self.textRGPD.heightAnchor.constraint(equalToConstant: self.view.frame.height/3)


        // button
        let cons_button_right = NSLayoutConstraint(item: self.button!, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -40)

        let cons_button_bottom = NSLayoutConstraint(item: self.button!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -70)
        
        let cons_button_width = self.button.widthAnchor.constraint(equalToConstant: 100)
        //checkbox

        let cons_check_left = NSLayoutConstraint(item: self.checkbox!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 20)

        let cons_check_bottom = NSLayoutConstraint(item: self.checkbox!, attribute: .bottom, relatedBy: .equal, toItem: self.button, attribute: .top, multiplier: 1, constant: -70)

        let cons_check_width = self.checkbox.widthAnchor.constraint(equalToConstant: 20)
        let cons_check_height = self.checkbox.heightAnchor.constraint(equalToConstant: 20)
        
        
        // consent label
        let cons_consent_left = NSLayoutConstraint(item: self.consentLabel!, attribute: .left, relatedBy: .equal, toItem: self.checkbox, attribute: .right, multiplier: 1, constant: 20)
        
        let cons_consent_bottom = NSLayoutConstraint(item: self.consentLabel!, attribute: .bottom, relatedBy: .equal, toItem: self.button, attribute: .bottom, multiplier: 1, constant: -70)
        
        let cons_consent_width = self.consentLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50)
        let cons_consent_height = self.consentLabel.heightAnchor.constraint(equalToConstant: 70)
        
        //Constraints active
        NSLayoutConstraint.activate([
            cons_titre_top, cons_titre_left, // titre
            cons_subtitle_top, cons_subtitle_left, // sous titre
            cons_text_top, cons_text_left, cons_text_width, cons_text_height, // text rgpd
            cons_button_right, cons_button_bottom, cons_button_width, // button
            cons_check_left, cons_check_height, cons_check_width, cons_check_bottom, // checkbox
            cons_consent_left, cons_consent_bottom, cons_consent_width, cons_consent_height // consent


        ])

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @objc func onCheckBoxValueChange(_ sender: CheckBoxView) {

        let pref = UserPrefs.getInstance()
        pref.setPrefs(key: "rgpd_consent", value: sender.isChecked)
    }
}
