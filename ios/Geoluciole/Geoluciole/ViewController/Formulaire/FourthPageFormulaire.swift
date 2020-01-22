//
//  ForthPageFormulaire.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 20/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FourthPageFormulaire: ParentModalViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.text = "quatrième page"
        label.translatesAutoresizingMaskIntoConstraints = false

        self.rootView.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            label.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            label.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    override func viewDidAppear(_ animated: Bool) {

    }
}
