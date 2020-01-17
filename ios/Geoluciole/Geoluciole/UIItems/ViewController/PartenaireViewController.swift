//
//  PartenaireViewController.swift
//  Geoluciole
//
//  Created by Laurent RAYEZ on 15/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit


class PartenaireViewController: ParentViewController /*UITableViewDelegate, UITableViewDataSource*/ {

    let nomDesPartenaires = ["logo_l3i", "logo_ULR"]
    let descriptionPartenaire = ["Le laboratoire d'informatique", "La Rochelle Université\nTechnoforum"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rootView.backgroundColor = .white
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = Constantes.DESC_PROJET
        tv.textAlignment = .justified
        
        let btonOk = CustomUIButton()
        btonOk.setTitle("Fermer", for: .normal)
        btonOk.setStyle(style: .defaultStyle)
        
        let zonePartenaire = UIView()
        zonePartenaire.backgroundColor = .white
        
        let uv_ulr = UIImageView()
        let ulr_img = UIImage(named: "logo_ulr")
        uv_ulr.translatesAutoresizingMaskIntoConstraints = false
        uv_ulr.contentMode = .scaleAspectFit
        uv_ulr.image = ulr_img

        let uv_l3i = UIImageView()
        let L3I_img = UIImage(named: "logo_l3i")
        uv_l3i.image = L3I_img
        uv_l3i.translatesAutoresizingMaskIntoConstraints = false
        uv_l3i.contentMode = .scaleAspectFit



        let uv_lienss = UIImageView()
        let lienss_img = UIImage(named: "logo_lienss")
        uv_lienss.image = lienss_img
        uv_lienss.translatesAutoresizingMaskIntoConstraints = false
        uv_lienss.contentMode = .scaleAspectFit

        let uv_cnrs = UIImageView()
        let cnrs_img = UIImage(named: "logo_cnrs")
        uv_cnrs.image = cnrs_img
        uv_cnrs.translatesAutoresizingMaskIntoConstraints = false
        uv_cnrs.contentMode = .scaleAspectFit

        zonePartenaire.addSubview(uv_ulr)
        zonePartenaire.addSubview(uv_cnrs)
        zonePartenaire.addSubview(uv_lienss)
        zonePartenaire.addSubview(uv_l3i)

        NSLayoutConstraint.activate([
            uv_ulr.topAnchor.constraint(equalTo: zonePartenaire.topAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            uv_ulr.widthAnchor.constraint(equalTo: zonePartenaire.widthAnchor, multiplier: 0.25),
            uv_ulr.heightAnchor.constraint(equalTo: uv_ulr.widthAnchor),
            uv_ulr.centerXAnchor.constraint(equalTo: zonePartenaire.centerXAnchor),

            uv_lienss.topAnchor.constraint(equalTo: uv_ulr.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            uv_lienss.rightAnchor.constraint(equalTo: uv_cnrs.leftAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            uv_lienss.widthAnchor.constraint(equalTo: zonePartenaire.widthAnchor, multiplier: 0.25 ),
            uv_lienss.heightAnchor.constraint(equalTo: uv_lienss.widthAnchor),
            
            uv_cnrs.topAnchor.constraint(equalTo: uv_ulr.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            uv_cnrs.centerXAnchor.constraint(equalTo: zonePartenaire.centerXAnchor),
            uv_cnrs.widthAnchor.constraint(equalTo: zonePartenaire.widthAnchor, multiplier: 0.25 ),
            uv_cnrs.heightAnchor.constraint(equalTo: uv_cnrs.widthAnchor),
            
            uv_l3i.topAnchor.constraint(equalTo: uv_ulr.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            uv_l3i.leftAnchor.constraint(equalTo: uv_cnrs.rightAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            uv_l3i.widthAnchor.constraint(equalTo: zonePartenaire.widthAnchor, multiplier: 0.25 ),
            uv_l3i.heightAnchor.constraint(equalTo: uv_l3i.widthAnchor),
        ])
        
        btonOk.addTarget(self, action: #selector(closeModal), for: .touchUpInside)

        btonOk.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(btonOk)

        NSLayoutConstraint.activate([
            btonOk.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
            btonOk.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -10),
            btonOk.heightAnchor.constraint(equalToConstant: 50),

        ])
       
        tv.backgroundColor = .white
        tv.textColor = .black
        tv.font = UIFont.preferredFont(forTextStyle: .body)
        tv.adjustsFontForContentSizeCategory = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(tv)

        NSLayoutConstraint.activate([
            tv.topAnchor.constraint(equalTo: btonOk.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            tv.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            tv.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            tv.heightAnchor.constraint(equalTo: self.rootView.heightAnchor, multiplier: 0.50)
        ])
    
        self.rootView.addSubview(zonePartenaire)
        zonePartenaire.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            zonePartenaire.topAnchor.constraint(equalTo: tv.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            zonePartenaire.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            zonePartenaire.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            zonePartenaire.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL)
        ])

        self.titleBar.isHidden = true
        self.rootView.backgroundColor = .backgroundDefault

    }

    @objc func closeModal() {
        dismiss(animated: true, completion: nil)
    }

}
