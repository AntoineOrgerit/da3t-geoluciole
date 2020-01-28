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

    fileprivate var levelNumberLabel: CustomUILabel!
    fileprivate var progressBar: UIProgressView!
    fileprivate let progressBarHeight: CGFloat = 15
    var onProgressBarFinish: (()-> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Label indiquant le niveau
        self.levelNumberLabel = CustomUILabel()
        self.levelNumberLabel.text = Tools.getTranslate(key: "stay_progression")
        self.levelNumberLabel.setStyle(style: .subtitleBold)
        self.levelNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        self.levelNumberLabel.textAlignment = .left
        self.addSubview(self.levelNumberLabel)

        // progressview
        self.progressBar = UIProgressView()
        self.progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.progressBar.layer.cornerRadius = self.progressBarHeight / 2
        self.progressBar.clipsToBounds = true
        self.progressBar.progressTintColor = .colorProgressBar
        self.progressBar.setProgress(0, animated: true)
        self.addSubview(self.progressBar)

        NSLayoutConstraint.activate([

            self.heightAnchor.constraint(equalTo: self.levelNumberLabel.heightAnchor, constant: Constantes.FIELD_SPACING_VERTICAL + self.progressBarHeight),

            self.levelNumberLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.levelNumberLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.levelNumberLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.levelNumberLabel.rightAnchor.constraint(equalTo: self.rightAnchor),

            self.progressBar.heightAnchor.constraint(equalToConstant: self.progressBarHeight),
            self.progressBar.topAnchor.constraint(equalTo: self.levelNumberLabel.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.progressBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            self.progressBar.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func setProgress(value: Float) {
        self.progressBar.progress = value
        if self.progressBar.progress >= 1 {
            self.onProgressBarFinish?()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
