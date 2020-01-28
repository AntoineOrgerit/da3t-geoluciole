//
//  HomeViewController.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import UIKit

class HomeViewController: ParentViewController {

    fileprivate var showLevelView: ShowLevelView!
    fileprivate var lastTrophyView: LastTrophyView!
    fileprivate var collectDataSwitchView: CollectDataSwitchView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let dhDeb = UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_START_ENGAGEMENT)
        let dhFin = UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_END_ENGAGEMENT)
        if dhDeb == "" || dhFin == "" {
            let currentDate = Date()
            let dateEnd = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
            UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_DATE_START_ENGAGEMENT, value: Tools.convertDate(date: currentDate))
            UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_DATE_END_ENGAGEMENT, value: Tools.convertDate(date: dateEnd!))
        }

        // LevelView
        self.showLevelView = ShowLevelView()
        self.showLevelView.onProgressBarFinish = {
            self.collectDataSwitchView.setSwitch(value: false)
        }
        self.showLevelView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.showLevelView)

        // LastTrophyView
        let wrap = UIView()
        wrap.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(wrap)
        self.lastTrophyView = LastTrophyView()
        self.lastTrophyView.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(self.lastTrophyView)

        // CollectDataSwitch
        self.collectDataSwitchView = CollectDataSwitchView()
        self.collectDataSwitchView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.collectDataSwitchView)

        // Constraints ShowLevelView
        NSLayoutConstraint.activate([
            self.showLevelView.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.showLevelView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.showLevelView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING)
        ])

        // Constraints LastTrophyView
        NSLayoutConstraint.activate([
            wrap.topAnchor.constraint(equalTo: self.showLevelView.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            wrap.bottomAnchor.constraint(equalTo: self.collectDataSwitchView.topAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            wrap.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            wrap.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),

            self.lastTrophyView.centerXAnchor.constraint(equalTo: wrap.centerXAnchor),
            self.lastTrophyView.centerYAnchor.constraint(equalTo: wrap.centerYAnchor),
            self.lastTrophyView.widthAnchor.constraint(equalTo: wrap.widthAnchor)
        ])

        // Constraints CollectDataSwitchView
        NSLayoutConstraint.activate([
            self.collectDataSwitchView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            self.collectDataSwitchView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.collectDataSwitchView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING)
        ])
    }

    func calcProgress() {
        let date = Date()
        let stringDate = Tools.convertDate(date: date)
        let currentDate = Tools.convertDateGMT01(date: stringDate)

        let dateDebut = Tools.convertDateGMT01(date: UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_START_ENGAGEMENT))
        let dateFin = Tools.convertDateGMT01(date: UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_END_ENGAGEMENT))

        let pct: Float = Float((100 * currentDate.timeIntervalSince(dateDebut) / (dateFin.timeIntervalSince(dateDebut))) / 100)
        if Constantes.DEBUG {
            print("ProgressBar : \(pct)")
        }
        self.showLevelView.setProgress(value: pct)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.collectDataSwitchView.isHidden = !self.userPrefs.bool(forKey: UserPrefs.KEY_RGPD_CONSENT)

        let send = self.userPrefs.bool(forKey: "send_data")
        self.collectDataSwitchView.setSwitch(value: send)
        self.calcProgress()

        if let _ = self.userPrefs.object(forKey: UserPrefs.KEY_LAST_BADGE) {
            self.lastTrophyView.setImage(nom: self.userPrefs.string(forKey: UserPrefs.KEY_LAST_BADGE))
        } else {
            self.lastTrophyView.setImage(nom: "no-badge")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // On affiche le consentement de RGPD pour le GPS
        if self.userPrefs.object(forKey: UserPrefs.KEY_RGPD_CONSENT) == nil {
            let rgpdController = GPSConsentRGPDViewController()
            rgpdController.modalPresentationStyle = .fullScreen
            self.present(rgpdController, animated: true)
        } else {
            // On affiche ensuite le constement pour le formulaire
            if !self.userPrefs.bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
                let formRgpdController = FormConsentRGPDViewController()
                formRgpdController.modalPresentationStyle = .fullScreen
                self.present(formRgpdController, animated: true)
            } else {
                // On affiche le formulaire
                
            }
        }

        // On affiche ensuite le constement pour le formulaire
        if !self.userPrefs.bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
            let formRgpdController = FormulaireConsentRGPDViewController()
            formRgpdController.modalPresentationStyle = .fullScreen
            self.present(formRgpdController, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

