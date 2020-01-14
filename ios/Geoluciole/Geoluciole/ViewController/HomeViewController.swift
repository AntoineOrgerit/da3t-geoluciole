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
    let param = Params.getInstance().param

    override func viewDidLoad() {
        super.viewDidLoad()

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
            self.showLevelView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.showLevelView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor),
            self.showLevelView.widthAnchor.constraint(equalTo: self.rootView.widthAnchor)
        ])
        
        // Constraints LastTrophyView
        NSLayoutConstraint.activate([
            wrap.topAnchor.constraint(equalTo: self.showLevelView.bottomAnchor),
            wrap.bottomAnchor.constraint(equalTo: self.collectDataSwitchView.topAnchor),
            wrap.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            wrap.rightAnchor.constraint(equalTo: self.rootView.rightAnchor),
            
            self.lastTrophyView.centerXAnchor.constraint(equalTo: wrap.centerXAnchor),
            self.lastTrophyView.centerYAnchor.constraint(equalTo: wrap.centerYAnchor),
            self.lastTrophyView.widthAnchor.constraint(equalTo: self.rootView.widthAnchor)
        ])

        // Constraints CollectDataSwitchView
        NSLayoutConstraint.activate([
            self.collectDataSwitchView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            self.collectDataSwitchView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.collectDataSwitchView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let send = param.bool(forKey: "send_data")
        self.collectDataSwitchView.setSwitch(value: send)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

