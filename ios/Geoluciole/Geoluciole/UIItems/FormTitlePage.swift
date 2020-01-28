//
//  FormTitlePage.swift
//  Geoluciole
//
//  Created by Laurent RAYEZ on 21/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FormTitlePage: UIView {

    init(title: String, pageIndex: String) {
        super.init(frame: .zero)
        
        let titre = CustomUILabel()
        titre.setStyle(style: .titleBold)
        titre.text = title
        titre.numberOfLines = 0
        titre.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titre)

        let page = CustomUILabel()
        page.setStyle(style: .subtitleBold)
        page.text = pageIndex
        page.numberOfLines = 0
        page.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(page)
        
        NSLayoutConstraint.activate([

            self.heightAnchor.constraint(equalTo: titre.heightAnchor),

            titre.topAnchor.constraint(equalTo: self.topAnchor),
            titre.leftAnchor.constraint(equalTo: self.leftAnchor),

            page.rightAnchor.constraint(equalTo: self.rightAnchor),
            page.centerYAnchor.constraint(equalTo: titre.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
