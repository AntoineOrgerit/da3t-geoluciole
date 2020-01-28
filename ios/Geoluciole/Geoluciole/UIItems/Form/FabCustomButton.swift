//
//  FabCustomButton.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 22/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

@objc protocol BoutonsPrevNextDelegate {
    @objc optional func boutonsPrevNext(boutonsPrevNext: BoutonsPrevNext, onNext: Bool)
    @objc optional func boutonsPrevNext(boutonsPrevNext: BoutonsPrevNext, onPrevious: Bool)
}

class FabCustomButton: NSObject {

    static func createButton(type: ButtonType) -> BoutonsPrevNext {
        switch type {
        case .nextPrev:
            return BoutonsPrevNext()
        case .next:
            return BoutonNext()
        case .prev:
            return BoutonsPrev()
        case .valid:
            return BoutonValidation()
        }
    }
}

class BoutonsPrevNext: UIView {

    weak var delegate: BoutonsPrevNextDelegate?
    fileprivate var buttonNext: CustomUIButton!
    fileprivate var buttonPrevious: CustomUIButton!

    init() {
        super.init(frame: .zero)

        self.buttonNext = CustomUIButton()
        self.buttonNext.setStyle(style: .active)
        self.buttonNext.setTitle(Tools.getTranslate(key: "next_button"), for: .normal)
        self.buttonNext.translatesAutoresizingMaskIntoConstraints = false
        self.buttonNext.onClick = { [weak self] boutton in
            guard let strongSelf = self else { return }

            strongSelf.delegate?.boutonsPrevNext?(boutonsPrevNext: strongSelf, onNext: true)
        }
        self.addSubview(self.buttonNext)

        self.buttonPrevious = CustomUIButton()
        self.buttonPrevious.setStyle(style: .active)
        self.buttonPrevious.setTitle(Tools.getTranslate(key: "prev_button"), for: .normal)
        self.buttonPrevious.translatesAutoresizingMaskIntoConstraints = false
        self.buttonPrevious.onClick = { [weak self] boutton in
            guard let strongSelf = self else { return }

            strongSelf.delegate?.boutonsPrevNext?(boutonsPrevNext: strongSelf, onPrevious: true)
        }
        self.addSubview(self.buttonPrevious)

        NSLayoutConstraint.activate([
            self.buttonPrevious.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.buttonPrevious.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.buttonPrevious.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45),

            self.buttonNext.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.buttonNext.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.buttonNext.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45),

            self.topAnchor.constraint(equalTo: self.buttonPrevious.topAnchor),
            self.bottomAnchor.constraint(equalTo: self.buttonPrevious.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class BoutonsPrev: BoutonsPrevNext {

    override init() {
        super.init()
        self.buttonNext.isHidden = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class BoutonNext: BoutonsPrevNext {

    override init() {
        super.init()
        self.buttonPrevious.isHidden = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class BoutonValidation: BoutonsPrevNext {
   
    override init() {
        super.init()
        self.buttonNext.setTitle("Valider", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
