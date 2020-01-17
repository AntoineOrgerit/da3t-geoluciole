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
            icon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constantes.TITLE_BAR_PADDING_HORIZONTAL),
            icon.heightAnchor.constraint(equalToConstant: statusBarHeight),
            icon.widthAnchor.constraint(equalToConstant: statusBarHeight),
            
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            titleLabel.heightAnchor.constraint(equalToConstant: statusBarHeight),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Constantes.TITLE_BAR_PADDING_HORIZONTAL)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
