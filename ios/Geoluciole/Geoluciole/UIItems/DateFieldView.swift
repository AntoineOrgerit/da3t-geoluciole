//
//  DateFieldView.swift
//  Geoluciole
//
//  Created by local192 on 14/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class DateFieldView: UIView {

    fileprivate var titleLabel: UILabel!
    fileprivate var dateLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.titleLabel = UILabel()
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        self.titleLabel.adjustsFontForContentSizeCategory = true
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.text = ""
        self.titleLabel.textAlignment = .left
        self.addSubview(self.titleLabel)

        let wrapDate = UIView()
        wrapDate.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapDate)

        self.dateLabel = UILabel()
        self.dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.dateLabel.adjustsFontForContentSizeCategory = true
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dateLabel.text = Tools.convertDate(date: Date())
        wrapDate.addSubview(self.dateLabel)

        let dropDown = UIImageView()
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        dropDown.contentMode = .scaleAspectFit
        dropDown.image = UIImage(named: "drop-down")
        wrapDate.addSubview(dropDown)

        NSLayoutConstraint.activate([

            self.bottomAnchor.constraint(equalTo: wrapDate.bottomAnchor),

            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor),

            wrapDate.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            wrapDate.leftAnchor.constraint(equalTo: self.leftAnchor),
            wrapDate.rightAnchor.constraint(equalTo: self.rightAnchor),
            wrapDate.widthAnchor.constraint(equalTo: self.widthAnchor),
            wrapDate.bottomAnchor.constraint(equalTo: self.dateLabel.bottomAnchor),

            self.dateLabel.topAnchor.constraint(equalTo: wrapDate.topAnchor),
            self.dateLabel.leftAnchor.constraint(equalTo: wrapDate.leftAnchor),
            self.dateLabel.rightAnchor.constraint(equalTo: dropDown.leftAnchor),

            dropDown.centerYAnchor.constraint(equalTo: self.dateLabel.centerYAnchor),
            dropDown.rightAnchor.constraint(equalTo: wrapDate.rightAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            dropDown.widthAnchor.constraint(equalToConstant: 15),
            dropDown.heightAnchor.constraint(equalTo: dropDown.widthAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setTitle(title: String) {
        self.titleLabel.text = title
    }
}
