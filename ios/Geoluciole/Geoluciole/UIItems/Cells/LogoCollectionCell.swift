//
//  LogocollectionCell.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 16/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class LogoCollectionCell: UITableViewCell {
    var imageLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "logo_l3i")
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var descrPartenaire: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "test"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imageLogo)
        contentView.addSubview(descrPartenaire)
        
        NSLayoutConstraint.activate([
            imageLogo.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageLogo.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageLogo.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            imageLogo.heightAnchor.constraint(equalTo: imageLogo.widthAnchor),
            
            descrPartenaire.topAnchor.constraint(equalTo: contentView.topAnchor),
            descrPartenaire.leftAnchor.constraint(equalTo: imageLogo.rightAnchor, constant: 10),
            
            contentView.bottomAnchor.constraint(equalTo: imageLogo.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
