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

    init(titre: String, page: String) {
        super.init(frame: .zero)
        self.setuptitle(title: titre, pg: page)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }

    func setuptitle(title: String, pg: String) {

        let titre = CustomUILabel()
        titre.setStyleLabel(style: .FormTitle)
        titre.text = title
        titre.numberOfLines = 0
        titre.translatesAutoresizingMaskIntoConstraints = false

        let page = CustomUILabel()
        page.setStyleLabel(style: .FormTitle)
        page.text = pg
        page.numberOfLines = 0
        page.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(titre)
        self.addSubview(page)


        NSLayoutConstraint.activate([
            
            self.heightAnchor.constraint(equalTo: titre.heightAnchor),

            titre.topAnchor.constraint(equalTo: self.topAnchor),
//            titre.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            titre.leftAnchor.constraint(equalTo: self.leftAnchor),


//            page.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            page.rightAnchor.constraint(equalTo: self.rightAnchor),
//            page.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            page.topAnchor.constraint(equalTo: self.topAnchor),

        ])
    }
}
