//
//  SecondPageFormulaire.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 20/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class SecondPageFormulaire: ParentModalViewController, BoutonsPrevNextDelegate {


    var onNextButton: (() -> Void)?
    var onPreviousButton: (() -> Void)?
    var scrollView: UIScrollView!
    var contentView: UIView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Permet de resize le content pour permettre le scroll
        self.scrollView.contentSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height + Constantes.FIELD_SPACING_VERTICAL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let titre2 = CustomTitleForm(titre: "", page: "")
        titre2.translatesAutoresizingMaskIntoConstraints = false

        let aff_page: String
        if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
            aff_page = "2/4"
        } else {
            aff_page = "1/3"
        }
        titre2.setuptitle(title: Constantes.TITRE_FORMULAIRE, pg: aff_page)

        let boutonsNav = fabCustomButton.createButton(type: .nextPrev) as! BoutonsPrevNext
        boutonsNav.delegate = self
        boutonsNav.translatesAutoresizingMaskIntoConstraints = false

        self.scrollView = UIScrollView()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false

        let formulaire = FormulaireDateHeurePage2()
        formulaire.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView = UIView()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(formulaire)

        self.rootView.addSubview(titre2)
        self.rootView.addSubview(self.scrollView)
        self.rootView.addSubview(boutonsNav)

        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.contentView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.rootView.widthAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: formulaire.bottomAnchor)
        ])

        NSLayoutConstraint.activate([

            titre2.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            titre2.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            titre2.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),

            self.scrollView.topAnchor.constraint(equalTo: titre2.bottomAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.scrollView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.scrollView.bottomAnchor.constraint(equalTo: boutonsNav.topAnchor),

            boutonsNav.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            boutonsNav.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            boutonsNav.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL)
        ])
        
        NSLayoutConstraint.activate([
            
            formulaire.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            formulaire.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            formulaire.leftAnchor.constraint(equalTo: self.contentView.leftAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func boutonsPrevNext(boutonsPrevNext: BoutonsPrevNext, onNext: Bool) {
        self.onNextButton?()
    }

    func boutonsPrevNext(boutonsPrevNext: BoutonsPrevNext, onPrevious: Bool) {
        self.onPreviousButton?()
    }
}
