//
//  FormDropDownListView.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 25/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FormDropDownListView: UIView, UITableViewDelegate, UITableViewDataSource{
    
    var titre: CustomUILabel!
    var btonQuestion: CustomUIButton!
    var dropDown: UITableView!
    
    let DATA: [String] = [Tools.getTranslate(key: "single"), Tools.getTranslate(key: "with_familly"), Tools.getTranslate(key: "with_friends"),Tools.getTranslate(key: "grouped"), Tools.getTranslate(key: "other")]
    
    init() {
        super.init(frame: .zero)
        
        self.titre = CustomUILabel()
        self.titre.text = Tools.getTranslate(key: "with_who_journey")
        self.titre.setStyle(style: .subtitleBold)
        self.titre.translatesAutoresizingMaskIntoConstraints = false
        //self.titre.backgroundColor = .black
        self.addSubview(self.titre)
        
        self.btonQuestion = CustomUIButton()
        self.btonQuestion.setStyle(style: .defaultStyle)
        self.btonQuestion.titleLabel?.text = Tools.getTranslate(key: "choose_answer")
        self.btonQuestion.translatesAutoresizingMaskIntoConstraints = false
        //self.btonQuestion.backgroundColor = .green
        self.btonQuestion.onClick = { [weak self] button in
            guard let strongSelf = self else {
                return
            }
            strongSelf.deployDropDown()
        }
        self.addSubview(btonQuestion)
        
        self.dropDown = UITableView(frame: .zero, style: .plain )
        self.dropDown.backgroundColor = .purple
        self.dropDown.isHidden = true
        self.dropDown.translatesAutoresizingMaskIntoConstraints = false
        self.dropDown.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(dropDown)
        
        NSLayoutConstraint.activate([
        
            self.titre.topAnchor.constraint(equalTo: self.topAnchor),
            self.titre.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.titre.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            self.btonQuestion.topAnchor.constraint(equalTo: self.titre.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.btonQuestion.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.btonQuestion.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            self.dropDown.topAnchor.constraint(equalTo: self.btonQuestion.bottomAnchor),
            self.dropDown.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.dropDown.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.dropDown.heightAnchor.constraint(equalToConstant: 100),
            
            self.bottomAnchor.constraint(equalTo: self.dropDown.bottomAnchor),
            self.topAnchor.constraint(equalTo: self.titre.topAnchor)
        ])
        
        //self.dropDown.delegate = self
        self.dropDown.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func deployDropDown() -> Void {
        self.dropDown.isHidden = false
        self.dropDown.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DATA.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "test"//self.DATA[indexPath.row]
        return cell
    }
}

fileprivate class CellClass: UITableViewCell {
    
    
}
