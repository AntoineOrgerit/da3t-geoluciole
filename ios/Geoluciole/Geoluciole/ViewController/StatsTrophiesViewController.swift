//
//  StatsTrophiesViewController.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import UIKit

class StatsTrophiesViewController: ParentViewController {
    
    let noBadge = NoBadgeView()
    var statView = StatsView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(statView)
        noBadge.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(noBadge)
        NSLayoutConstraint.activate([
            statView.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            statView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING_HORIZONTAL),
            statView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING_HORIZONTAL),

            noBadge.topAnchor.constraint(equalTo: statView.bottomAnchor),
            noBadge.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor),
            noBadge.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            noBadge.rightAnchor.constraint(equalTo: self.rootView.rightAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statView.setValeurDist()
        
    }
}
