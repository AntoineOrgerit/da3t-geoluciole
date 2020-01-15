//
//  DurationOfEngagementFormView.swift
//  Geoluciole
//
//  Created by local192 on 14/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class DurationOfEngagementFormView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        let title = UILabel()
        title.text = "Durée d'engagement"
        title.adjustsFontForContentSizeCategory = true
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .left
        self.addSubview(title)

        let dateStartField = DateFieldView()
        dateStartField.setTitle(title: "Date de début")
        dateStartField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dateStartField)
        
        let dateEndField = DateFieldView()
        dateEndField.setTitle(title: "Date de fin")
        dateEndField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dateEndField)

        NSLayoutConstraint.activate([
            
            self.bottomAnchor.constraint(equalTo: dateStartField.bottomAnchor),
            
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.widthAnchor.constraint(equalTo: self.widthAnchor),
            title.leftAnchor.constraint(equalTo: self.leftAnchor),
            title.rightAnchor.constraint(equalTo: self.rightAnchor),

            dateStartField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            dateStartField.widthAnchor.constraint(equalTo: self.widthAnchor,multiplier: 0.5),
            dateStartField.leftAnchor.constraint(equalTo: self.leftAnchor),
            dateStartField.rightAnchor.constraint(equalTo: dateEndField.leftAnchor),
            
            dateEndField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            dateEndField.widthAnchor.constraint(equalTo: self.widthAnchor,multiplier: 0.5),
            dateEndField.leftAnchor.constraint(equalTo: dateStartField.rightAnchor),
            dateEndField.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
