//
//  FabricCustomButton.swift
//  Geoluciole
//
//  Created by Laurent RAYEZ on 22/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

@objc protocol ButtonsPrevNextDelegate {
    @objc optional func boutonsPrevNext(boutonsPrevNext: ButtonsPrevNext, onNext: Bool)
    @objc optional func boutonsPrevNext(boutonsPrevNext: ButtonsPrevNext, onPrevious: Bool)
}

class FabricCustomButton: NSObject {
    
    enum ButtonType {
        case nextPrev, next, prev, valid, refuseAccept
    }

    static func createButton(type: ButtonType) -> ButtonsPrevNext {
        switch type {
        case .nextPrev:
            return ButtonsPrevNext()
        case .next:
            return ButtonNext()
        case .prev:
            return ButtonPrevious()
        case .valid:
            return ButtonValidate()
        case .refuseAccept:
            return ButtonsRefuseAccept()
        }
    }
}

class ButtonsPrevNext: UIView {

    weak var delegate: ButtonsPrevNextDelegate?
    fileprivate var buttonNext: CustomUIButton!
    fileprivate var buttonPrevious: CustomUIButton!

    enum ButtonChoice {
        case next, previous
    }

    init() {
        super.init(frame: .zero)

        self.buttonNext = CustomUIButton()
        self.buttonNext.setStyle(style: .active)
        self.buttonNext.setTitle(Tools.getTranslate(key: "form_continue"), for: .normal)
        self.buttonNext.translatesAutoresizingMaskIntoConstraints = false
        self.buttonNext.onClick = { [weak self] boutton in
            guard let strongSelf = self else { return }

            strongSelf.delegate?.boutonsPrevNext?(boutonsPrevNext: strongSelf, onNext: true)
        }
        self.addSubview(self.buttonNext)

        self.buttonPrevious = CustomUIButton()
        self.buttonPrevious.setStyle(style: .active)
        self.buttonPrevious.setTitle(Tools.getTranslate(key: "form_previous"), for: .normal)
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

    func setDisabled(button: ButtonChoice) {
        switch button {

        case .next:
            self.buttonNext.setStyle(style: .disabled)
            self.buttonNext.isUserInteractionEnabled = false

        case .previous:
            self.buttonPrevious.setStyle(style: .disabled)
            self.buttonPrevious.isUserInteractionEnabled = false
        }
    }

    func setEnabled(button: ButtonChoice) {
        switch button {

        case .next:
            self.buttonNext.setStyle(style: .active)
            self.buttonNext.isUserInteractionEnabled = true

        case .previous:
            self.buttonPrevious.setStyle(style: .active)
            self.buttonPrevious.isUserInteractionEnabled = true
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

fileprivate class ButtonPrevious: ButtonsPrevNext {

    override init() {
        super.init()
        self.buttonNext.isHidden = true
    }

    func setEnabled() {
        super.setEnabled(button: .previous)
    }

    func setDisabled() {
        super.setDisabled(button: .previous)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

fileprivate class ButtonNext: ButtonsPrevNext {

    override init() {
        super.init()
        self.buttonPrevious.isHidden = true
    }

    func setEnabled() {
        super.setEnabled(button: .next)
    }

    func setDisabled() {
        super.setDisabled(button: .next)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

fileprivate class ButtonValidate: ButtonsPrevNext {

    override init() {
        super.init()
        self.buttonNext.setTitle(Tools.getTranslate(key: "form_submit"), for: .normal)
    }

    func setEnabled() {
        super.setEnabled(button: .next)
    }

    func setDisabled() {
        super.setDisabled(button: .next)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

fileprivate class ButtonsRefuseAccept: ButtonsPrevNext {

    override init() {
        super.init()
        
        self.buttonNext.setTitle(Tools.getTranslate(key: "action_accept"), for: .normal)
        self.buttonPrevious.setTitle(Tools.getTranslate(key: "action_refused"), for: .normal)
        self.buttonPrevious.setStyle(style: .delete)
    }

    override func setEnabled(button: ButtonChoice) {
        switch button {

        case .next:
            self.buttonNext.setStyle(style: .active)
            self.buttonNext.isUserInteractionEnabled = true

        case .previous:
            self.buttonPrevious.setStyle(style: .delete)
            self.buttonPrevious.isUserInteractionEnabled = true
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
