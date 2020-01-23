//
//  BadgesCollectionViewCell.swift
//  Geoluciole
//
//  Created by local192 on 14/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class BadgesCollectionViewCell: UICollectionViewCell {

    fileprivate var iv: CustomUIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.iv = CustomUIImageView(frame: .zero)
        self.iv.image = UIImage(named: "1km")
        self.iv.contentMode = . scaleAspectFit
        self.iv.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.iv)

        NSLayoutConstraint.activate([
            self.iv.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.iv.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.iv.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.iv.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setImage(name: String) {
        self.iv.image = UIImage(named: name) ?? UIImage(named: "no-img")
    }
}
