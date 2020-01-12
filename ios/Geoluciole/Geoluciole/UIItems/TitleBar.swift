//
//  TitleBar.swift
//  Geoluciole
//
//  Created by local192 on 10/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class TitleBar: UIView, UIGestureRecognizerDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .backgroundTitleBar

        let statusBarHeight = Tools.getStatusBarHeight()

        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = Tools.getAppName()
        titleLabel.textAlignment = .left
        self.addSubview(titleLabel)

        let icon = CustomUIImageView(frame: .zero)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(named: "question-circle")
        icon.contentMode = .scaleAspectFit
        icon.onClick = { [weak self] _ in
            guard let strongSelf = self else { return }
            
            let alert = UIAlertController(title: nil, message: "Not implemented yet", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            strongSelf.findViewController()!.present(alert, animated: true, completion: nil)
        }
        self.addSubview(icon)

        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: Constantes.TITLE_BAR_PADDING_HORIZONTAL),
            titleLabel.heightAnchor.constraint(equalToConstant: statusBarHeight),
            titleLabel.rightAnchor.constraint(equalTo: icon.leftAnchor),

            icon.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            NSLayoutConstraint(item: icon, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -Constantes.TITLE_BAR_PADDING_HORIZONTAL),
            icon.heightAnchor.constraint(equalToConstant: statusBarHeight),
            icon.widthAnchor.constraint(equalToConstant: statusBarHeight)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
