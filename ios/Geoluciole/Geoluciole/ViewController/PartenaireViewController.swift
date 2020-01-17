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
//    let tabView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
//        tableView.backgroundColor = .blue
//        return tableView
//    }()
    let tv: UITextView = {
        let text = UITextView()
        text.text = Constantes.TEXT_RGPD
        return text
    }()
    let btonOk: UIButton = {
        let okBtn = CustomUIButton()
        okBtn.setTitle("Fermer", for: .normal)
        okBtn.setStyle(style: .defaultStyle)
        return okBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupBtonOk()
        setupTextView()
//        setupTableView()

        self.titleBar.isHidden = true
        self.rootView.backgroundColor = .backgroundDefault

    }

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return nomDesPartenaires.count
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tabView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! LogoCollectionCell
//        cell.imageLogo.image = UIImage(named: nomDesPartenaires[indexPath.item])
//        cell.descrPartenaire.text = descriptionPartenaire[indexPath.item]
//        return cell
//    }
    @objc func closeModal() {
        dismiss(animated: true, completion: nil)
    }
//    func setupTableView() {
//        self.rootView.addSubview(tabView)
//
//        tabView.translatesAutoresizingMaskIntoConstraints = false
//        tabView.backgroundColor = .white
//        tabView.register(LogoCollectionCell.self, forCellReuseIdentifier: "cellId")
//
//        NSLayoutConstraint.activate([
//            tabView.topAnchor.constraint(equalTo: btonOk.bottomAnchor),
//            tabView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor),
//            tabView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor),
//            tabView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor)
//        ])
//
//        tabView.delegate = self
//        tabView.dataSource = self
//    }
    func setupBtonOk() {

        btonOk.addTarget(self, action: #selector(closeModal), for: .touchUpInside)

        btonOk.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(btonOk)

        NSLayoutConstraint.activate([
            btonOk.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
            btonOk.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -10),
            btonOk.heightAnchor.constraint(equalToConstant: 50),

        ])
    }
    func setupTextView(){
        self.rootView.addSubview(tv)
        tv.backgroundColor = .white
        tv.textColor = .black
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tv.topAnchor.constraint(equalTo: btonOk.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            tv.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.FIELD_SPACING_HORIZONTAL),
            tv.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.FIELD_SPACING_HORIZONTAL),
            tv.heightAnchor.constraint(equalTo: self.rootView.heightAnchor, multiplier: 0.50)
        ])
        
        
    }
}
