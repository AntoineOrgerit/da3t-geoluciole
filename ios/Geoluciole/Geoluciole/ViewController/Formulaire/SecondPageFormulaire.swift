//
//  SecondPageFormulaire.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 20/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class SecondPageFormulaire: ParentModalViewController {
    //var onNextButton: (()->void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lblArrive = CustomTextFieldForm()
        lblArrive.setUpTextField(text: "Date d'arrivée")
        
        let lblDepart = CustomTextFieldForm()
        lblDepart.setUpTextField(text:"Date prévue de départ")
        
        self.rootView.addSubview(lblArrive)
        self.rootView.addSubview(lblDepart)

        NSLayoutConstraint.activate([
            lblArrive.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            lblArrive.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            lblArrive.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            lblArrive.heightAnchor.constraint(equalToConstant: Constantes.FIELD_SPACING_HORIZONTAL),

            lblDepart.topAnchor.constraint(equalTo: lblArrive.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            lblDepart.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            lblDepart.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            lblDepart.heightAnchor.constraint(equalToConstant: Constantes.FIELD_SPACING_HORIZONTAL),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
