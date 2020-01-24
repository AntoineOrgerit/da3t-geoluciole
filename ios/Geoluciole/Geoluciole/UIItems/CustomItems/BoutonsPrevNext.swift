//
//  BoutonsPrevNext.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 22/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

protocol BoutonsPrevNextDelegate: NSObject {
    func boutonsPrevNext(boutonsPrevNext: BoutonsPrevNext, onNext: Bool)
    func boutonsPrevNext(boutonsPrevNext: BoutonsPrevNext, onPrevious: Bool)
}
protocol BoutonsPrevDelegate: NSObject {
    func clickPrev(boutonsNext: BoutonsPrev)
}
protocol BoutonsNextDelegate: NSObject {
    func clickNext(boutonsNext: BoutonNext)
}
protocol BoutonValidationDelegate: NSObject {
    func clickValidation(boutonVal: BoutonValidation)
}
class fabCustomButton: NSObject {
    override init() {
        super.init()
    }
    static func createButton(type: ButtonType) -> UIView{
        switch type {
        case .nextPrev:
            return BoutonsPrevNext()
        case .next:
            return BoutonNext()
        case .prev:
            return BoutonsPrev()
        case .valid:
            return BoutonValidation()
        default:
            return UIButton()
        }
    }
}
class BoutonsPrevNext: UIView {

    weak var delegate: BoutonsPrevNextDelegate?

    init() {
        super.init(frame: .zero)

        self.translatesAutoresizingMaskIntoConstraints = false

        let btonNext = CustomUIButton(frame: .zero)
        btonNext.setStyle(style: .active)
        btonNext.setTitle("Suivant", for: .normal)
        btonNext.translatesAutoresizingMaskIntoConstraints = false

        btonNext.onClick = { [weak self] boutton in
            guard let strongSelf = self else { return }

            strongSelf.delegate?.boutonsPrevNext(boutonsPrevNext: strongSelf, onNext: true)
        }

        let btonPreview = CustomUIButton(frame: .zero)
        btonPreview.setStyle(style: .active)
        btonPreview.setTitle("Précédent", for: .normal)
        btonPreview.translatesAutoresizingMaskIntoConstraints = false

        btonPreview.onClick = { [weak self] boutton in
            guard let strongSelf = self else { return }

            strongSelf.delegate?.boutonsPrevNext(boutonsPrevNext: strongSelf, onPrevious: true)
        }

        self.addSubview(btonNext)
        self.addSubview(btonPreview)

        NSLayoutConstraint.activate([
            btonPreview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            btonPreview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),

            btonNext.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            btonNext.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            self.heightAnchor.constraint(equalTo: btonNext.heightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class BoutonsPrev: UIView {

    weak var delegate: BoutonsPrevDelegate?

    init() {
        super.init(frame: .zero)

        let btonPrev = CustomUIButton(frame: .zero)
        btonPrev.setStyle(style: .active)
        btonPrev.setTitle("Précédent", for: .normal)
        btonPrev.translatesAutoresizingMaskIntoConstraints = false

        btonPrev.onClick = { [weak self] boutton in
            guard let strongSelf = self else { return }

            strongSelf.delegate?.clickPrev(boutonsNext: strongSelf)
        }
        self.addSubview(btonPrev)

        NSLayoutConstraint.activate([
            btonPrev.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            btonPrev.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            self.heightAnchor.constraint(equalTo: btonPrev.heightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class BoutonNext: UIView {

    weak var delegate: BoutonsNextDelegate?

   init() {
    super.init(frame: .zero)

        let btonNext = CustomUIButton(frame: .zero)
        btonNext.setStyle(style: .active)
        btonNext.setTitle("Suivant", for: .normal)
        btonNext.translatesAutoresizingMaskIntoConstraints = false

        btonNext.onClick = { [weak self] boutton in
            guard let strongSelf = self else { return }

            strongSelf.delegate?.clickNext(boutonsNext: strongSelf)
        }
        self.addSubview(btonNext)

        NSLayoutConstraint.activate([
            btonNext.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            btonNext.rightAnchor.constraint(equalTo: self.leftAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            self.heightAnchor.constraint(equalTo: btonNext.heightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
class BoutonValidation: UIView {

    weak var delegate: BoutonValidationDelegate?

    init() {
        super.init(frame: .zero)

        let btonValidation = CustomUIButton(frame: .zero)
        btonValidation.setStyle(style: .active)
        btonValidation.setTitle("Valider", for: .normal)
        btonValidation.translatesAutoresizingMaskIntoConstraints = false

        btonValidation.onClick = { [weak self] boutton in
            guard let strongSelf = self else { return }

            strongSelf.delegate?.clickValidation(boutonVal: strongSelf)
        }
        self.addSubview(btonValidation)

        NSLayoutConstraint.activate([
            btonValidation.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            btonValidation.rightAnchor.constraint(equalTo: self.leftAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            self.heightAnchor.constraint(equalTo: btonValidation.heightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
