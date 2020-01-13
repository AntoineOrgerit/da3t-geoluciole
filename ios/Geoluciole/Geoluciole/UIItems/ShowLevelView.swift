//
//  ShowLevelView.swift
//  Geoluciole
//
//  Created by Jessy BARRITAULT on 13/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class ShowLevelView: UIView {

    fileprivate var levelNumberLabel: UILabel!
    fileprivate var progressBar: UIProgressView!
    fileprivate let progressBarHeight: CGFloat = 10

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Label indiquant le mot Niveau
        let levelLabel = UILabel()
        levelLabel.text = "Niveau :"
        levelLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        levelLabel.adjustsFontForContentSizeCategory = true
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.textAlignment = .center
        self.addSubview(levelLabel)

        // Label indiquant le niveau
        self.levelNumberLabel = UILabel()
        self.levelNumberLabel.text = "0"
        self.levelNumberLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        self.levelNumberLabel.adjustsFontForContentSizeCategory = true
        self.levelNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        self.levelNumberLabel.textAlignment = .left
        self.addSubview(self.levelNumberLabel)

        // progressview
        self.progressBar = UIProgressView()
        self.progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.progressBar.progress = 30
        self.progressBar.layer.cornerRadius = self.progressBarHeight / 2
        self.progressBar.clipsToBounds = true
        self.progressBar.progress = 35
        self.addSubview(self.progressBar)

        NSLayoutConstraint.activate([
            
            self.heightAnchor.constraint(equalTo: self.levelNumberLabel.heightAnchor, constant: Constantes.FIELD_SPACING_VERTICAL + self.progressBarHeight),
            
            levelLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            levelLabel.topAnchor.constraint(equalTo: self.topAnchor),
            levelLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            levelLabel.rightAnchor.constraint(equalTo: self.levelNumberLabel.leftAnchor),

            self.levelNumberLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            self.levelNumberLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.levelNumberLabel.leftAnchor.constraint(equalTo: levelLabel.rightAnchor),
            self.levelNumberLabel.rightAnchor.constraint(equalTo: self.rightAnchor),

            self.progressBar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constantes.PAGE_PADDING_HORIZONTAL),
            self.progressBar.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Constantes.PAGE_PADDING_HORIZONTAL),
            self.progressBar.heightAnchor.constraint(equalToConstant: self.progressBarHeight),
            self.progressBar.topAnchor.constraint(equalTo: self.levelNumberLabel.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
