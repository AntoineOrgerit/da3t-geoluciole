////
////  BadgesCollectionViewCell.swift
////  Geoluciole
////
////  Created by local192 on 14/01/2020.
////  Copyright © 2020 Université La Rochelle. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class BadgesCollectionViewCell: UICollectionViewCell {
//
//    private let bg: UIImageView = {
//        let iv = UIImageView()
//        iv.image = #imageLiteral(resourceName: "guillaume-briard-lSXpV8bDeMA-unsplash")
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.clipsToBounds = true
//        iv.contentMode = .scaleAspectFill
//        return iv
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        contentView.addSubview(bg)
//
//        NSLayoutConstraint.activate([
//            bg.topAnchor.constraint(equalTo: contentView.topAnchor),
//            bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//}
