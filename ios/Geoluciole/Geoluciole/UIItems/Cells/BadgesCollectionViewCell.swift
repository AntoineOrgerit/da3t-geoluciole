//
//  BadgesCollectionViewCell.swift
//  Geoluciole
//
//  Created by Laurent RAYEZ on 14/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class BadgesCollectionViewCell: UICollectionViewCell {

    fileprivate var iv: CustomUIImageView!
    var idBadge: Int!
    var onClick: ((BadgesCollectionViewCell) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.iv = CustomUIImageView(frame: .zero)
        self.iv.image = UIImage(named: "no-img")
        self.iv.contentMode = . scaleAspectFit
        self.iv.translatesAutoresizingMaskIntoConstraints = false
        self.iv.onClick = { [weak self] _ in
            guard let strongSelf = self else { return }

            strongSelf.onClick?(strongSelf)
        }
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
