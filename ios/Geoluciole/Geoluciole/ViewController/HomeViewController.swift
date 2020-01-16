//
//  FirstViewController.swift
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
        if  dhDeb == "" ||  dhFin == "" {
            let currentDate = Date()
            let dateEnd = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
            UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_DATE_START_ENGAGEMENT, value: Tools.convertDate(date: currentDate))
            UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_DATE_END_ENGAGEMENT, value: Tools.convertDate(date: dateEnd!))
        }
        
        // LevelView
        self.showLevelView = ShowLevelView()
        self.showLevelView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.showLevelView)

        // LastTrophyView
        let wrap = UIView()
        wrap.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(wrap)
        self.lastTrophyView = LastTrophyView(frame: .zero)
        self.lastTrophyView.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(self.lastTrophyView)

        // CollectDataSwitch
        self.collectDataSwitchView = CollectDataSwitchView()
        self.collectDataSwitchView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.collectDataSwitchView)
        
        // Constraints ShowLevelView
        NSLayoutConstraint.activate([
            self.showLevelView.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.showLevelView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING_HORIZONTAL),
            self.showLevelView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING_HORIZONTAL)
        ])

        // Constraints LastTrophyView
        NSLayoutConstraint.activate([
            wrap.topAnchor.constraint(equalTo: self.showLevelView.bottomAnchor),
            wrap.bottomAnchor.constraint(equalTo: self.collectDataSwitchView.topAnchor),
            wrap.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING_HORIZONTAL),
            wrap.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING_HORIZONTAL),

            self.lastTrophyView.centerXAnchor.constraint(equalTo: wrap.centerXAnchor),
            self.lastTrophyView.centerYAnchor.constraint(equalTo: wrap.centerYAnchor),
            self.lastTrophyView.widthAnchor.constraint(equalTo: wrap.widthAnchor)
        ])

        // Constraints CollectDataSwitchView
        NSLayoutConstraint.activate([
            self.collectDataSwitchView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            self.collectDataSwitchView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING_HORIZONTAL),
            self.collectDataSwitchView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING_HORIZONTAL)
        ])

        for view in self.rootView.subviews {
            view.clipsToBounds = true
        }
    }
    
    func calcProgress() {
        let date = Date()
        let stringDate = Tools.convertDate(date: date)
        let currentDate = Tools.convertDate(date: stringDate)
        
        let dateDebut = Tools.convertDateGMT01(date: UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_START_ENGAGEMENT))
        let dateFin = Tools.convertDateGMT01(date: UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_END_ENGAGEMENT))
        
        let pct : Float = Float((100 * currentDate.timeIntervalSince(dateDebut) / (dateFin.timeIntervalSince(dateDebut)))/100)
        print(pct)
        self.showLevelView.setProgress(value: pct)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let send = self.userPrefs.bool(forKey: "send_data")
        self.collectDataSwitchView.setSwitch(value: send)
        calcProgress()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !userPrefs.bool(forKey: UserPrefs.KEY_RGPD_CONSENT) {
            let rgpdController = GPSConsentRGPDViewController()
            rgpdController.modalPresentationStyle = .fullScreen
            self.present(rgpdController,animated: true, completion: nil)
       }
        
        if !userPrefs.bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
             let formRgpdController = FormulaireConsentRGPDViewController()
             formRgpdController.modalPresentationStyle = .fullScreen
             self.present(formRgpdController,animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

