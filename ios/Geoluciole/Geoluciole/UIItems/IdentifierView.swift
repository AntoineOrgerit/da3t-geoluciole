//
//  IdentifierView.swift
//  Geoluciole
//
//  Created by local192 on 18/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class IdentifierView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let title = CustomUILabel()
        title.text = "Mon identifiant"
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        title.adjustsFontForContentSizeCategory = true
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
        
        let id = CustomUILabel()
        id.text = String(Tools.getIdentifier())
        id.font = UIFont.preferredFont(forTextStyle: .body)
        id.adjustsFontForContentSizeCategory = true
        id.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(id)
        
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: self.leftAnchor),
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            id.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            id.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            id.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            self.bottomAnchor.constraint(equalTo: id.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
