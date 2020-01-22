//
//  ThirdPageFormulaire.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 20/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class ThirdPageFormulaire: ParentModalViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titre = CustomTitleForm()
        let aff_page: String
        if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT){
            aff_page = "3/4"
        } else {
            aff_page = "2/3"
        }
        titre.setuptitle(title: "Formulaire", pg: aff_page)
        titre.backgroundColor = .red
        /*
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        */
        let question1 = CustomQuestionForm()
        question1.setupQuestion(Question: "Présence d'enfants de moins de 13 ans", typeResp: .radioButton)
        
//        self.rootView.addSubview(titre)
//        self.rootView.addSubview(question1)
        
        NSLayoutConstraint.activate([
            titre.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            titre.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            titre.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            question1.topAnchor.constraint(equalTo: titre.bottomAnchor)
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
