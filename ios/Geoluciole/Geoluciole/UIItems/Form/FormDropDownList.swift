//
//  FormDropDownList.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 26/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FormDropDownList: UIStackView {

    fileprivate var bton: UIButton!
    fileprivate var bton2: UIButton!
    fileprivate var tbView: UITableView!
    var titre: CustomUILabel!
    fileprivate var Data: [String]!
    var onClick: ( ()-> Void )?
    
    init(data: [String]) {
        super.init(frame: .zero)

        self.Data = data

        self.titre = CustomUILabel()
        self.titre.text = Tools.getTranslate(key: "with_who_journey")
        self.titre.setStyle(style: .subtitleBold)
        self.titre.translatesAutoresizingMaskIntoConstraints = false
        //self.titre.backgroundColor = .black
        self.addArrangedSubview(self.titre)

        self.bton = UIButton()
        self.bton .setTitle(Tools.getTranslate(key: "click_to_choose_answer"), for: .normal)
        self.bton .translatesAutoresizingMaskIntoConstraints = false
        self.bton .backgroundColor = .orange
        self.bton.addTarget(self, action: #selector(FormDropDownList.displayTableView), for: .touchUpInside)
        self.addArrangedSubview(self.bton)


        self.tbView = UITableView()
        self.tbView.translatesAutoresizingMaskIntoConstraints = false
        self.tbView.register(CellTableView.self, forCellReuseIdentifier: "cellule")
        self.tbView.isHidden = true
        self.addArrangedSubview(self.tbView)


        NSLayoutConstraint.activate([

            self.bton.heightAnchor.constraint(equalToConstant: 50),

            self.tbView.topAnchor.constraint(equalTo: self.bton.bottomAnchor),
            self.tbView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.tbView.heightAnchor.constraint(equalToConstant: 150)

        ])
        self.tbView.delegate = self
        self.tbView.dataSource = self
    }

    @objc func displayTableView() {
        
        animateTbV(toggle: self.tbView.isHidden)
        self.onClick?()
    }
    func animateTbV(toggle: Bool) {
        if toggle {
            UIView.animate(withDuration: 0.3) {
                let tbV = self.arrangedSubviews[2]
                tbV.isHidden = false

            }
        } else {
            UIView.animate(withDuration: 0.3) {
                let tbV = self.arrangedSubviews[2]
                tbV.isHidden = true
            }
        }
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension FormDropDownList: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellule", for: indexPath)
        cell.textLabel?.text = self.Data[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.bton.setTitle(self.Data[indexPath.row], for: .normal)
        self.displayTableView()
    }
}

fileprivate class CellTableView: UITableViewCell {


}
