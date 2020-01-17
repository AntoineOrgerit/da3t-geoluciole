//
//  StatsTrophiesViewController.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import UIKit

class StatsTrophiesViewController: ParentViewController {

    fileprivate var noBadge: NoBadgeView!
    fileprivate var statView: StatsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.statView = StatsView()
        self.statView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.statView)

        self.noBadge = NoBadgeView()
        self.noBadge.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.noBadge)

        NSLayoutConstraint.activate([
            self.statView.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.statView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING_HORIZONTAL),
            self.statView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING_HORIZONTAL),

            self.noBadge.topAnchor.constraint(equalTo: self.statView.bottomAnchor),
            self.noBadge.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor),
            self.noBadge.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.noBadge.rightAnchor.constraint(equalTo: self.rootView.rightAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.statView.setValeurDist()
    }
}
