//
//  TitleBarView.swift
//  Geoluciole
//
//  Created by local192 on 10/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class TitleBarView: UIView, UIGestureRecognizerDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .backgroundDefault

        let statusBarHeight = Tools.getStatusBarHeight()

        let titleLabel = UILabel()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = Tools.getAppName()
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        self.addSubview(titleLabel)

        let icon = CustomUIImageView(frame: .zero)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(named: "luciole-blanche")
        icon.contentMode = .scaleAspectFit
        self.addSubview(icon)

        NSLayoutConstraint.activate([
            
            icon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            NSLayoutConstraint(item: icon, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: Constantes.TITLE_BAR_PADDING_HORIZONTAL),
            icon.heightAnchor.constraint(equalToConstant: statusBarHeight),
            icon.widthAnchor.constraint(equalToConstant: statusBarHeight),
            
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: icon, attribute: .right, multiplier: 1, constant: Constantes.TITLE_BAR_PADDING_HORIZONTAL),
            titleLabel.heightAnchor.constraint(equalToConstant: statusBarHeight),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
