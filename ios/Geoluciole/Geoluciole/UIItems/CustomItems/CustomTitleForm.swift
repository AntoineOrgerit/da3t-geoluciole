//
//  CustomTitleForm.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 21/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class CustomTitleForm: UIView {

    func setuptitle(title: String, pg: String) {
        
        let titre = CustomUILabel()
        titre.setStyleLabel(style: .Form)
        titre.text = title
        titre.textAlignment = .left
        //titre.numberOfLines = 0
        titre.translatesAutoresizingMaskIntoConstraints = false
        
        let page = CustomUILabel()
        page.setStyleLabel(style: .Form)
        page.text = pg
        page.textAlignment = .left
        //page.numberOfLines = 0
        titre.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(titre)
        self.addSubview(page)
    
        
        NSLayoutConstraint.activate([
            
            titre.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titre.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            titre.leftAnchor.constraint(equalTo: self.leftAnchor),
            
            page.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            page.leftAnchor.constraint(equalTo: titre.rightAnchor),
            page.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        ])
    }
}
