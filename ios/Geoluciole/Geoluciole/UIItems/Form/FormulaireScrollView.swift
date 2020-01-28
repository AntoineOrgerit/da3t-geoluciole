////
////  CustomScrollView.swift
////  Geoluciole
////
////  Created by ai.cgi niort on 22/01/2020.
////  Copyright © 2020 Université La Rochelle. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class FormulaireScrollView: UIView {
//    
//    
//    init() {
//        super.init(frame: .zero)
//        let question1 = CustomQuestionForm(quest: "Présence d'enfants de moins de 13 ans ?")
//        question1.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(question1)
//        
//        let question2 = CustomQuestionForm(quest: "Présence d'adolescents (13-18 ans) ?", typeResp: .radioButton)
//        question2.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(question2)
//        
//        let question3 = CustomQuestionForm(quest: "Visitez-vous La Rochelle pour la première fois ?", typeResp: .radioButton)
//        question3.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(question3)
//        
//        let question4 = CustomQuestionForm(quest: "Diriez-vous que vous connaissez bien La Rochelle ?", typeResp: .radioButton)
//        question4.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(question4)
//        
//        let question5 = CustomQuestionForm(quest: "Etes-vous déjà venus à La Rochelle + de 5 fois ?", typeResp: .radioButton)
//        question5.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(question5)
//        
//        let question6 = CustomQuestionForm(quest: "Avez-vous déjà vécu plus de deux mois à La Rochelle ?", typeResp: .radioButton)
//        question6.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(question6)
//        
//        NSLayoutConstraint.activate([
//            question1.topAnchor.constraint(equalTo: self.topAnchor),
//            question1.leftAnchor.constraint(equalTo: self.leftAnchor),
//            question1.rightAnchor.constraint(equalTo: self.rightAnchor),
//            
//            question2.topAnchor.constraint(equalTo: question1.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
//            question2.leftAnchor.constraint(equalTo: self.leftAnchor),
//            question2.rightAnchor.constraint(equalTo: self.rightAnchor),
//            
//            question3.topAnchor.constraint(equalTo: question2.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
//            question3.leftAnchor.constraint(equalTo: self.leftAnchor),
//            question3.rightAnchor.constraint(equalTo: self.rightAnchor),
//            
//            question4.topAnchor.constraint(equalTo: question3.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
//            question4.leftAnchor.constraint(equalTo: self.leftAnchor),
//            question4.rightAnchor.constraint(equalTo: self.rightAnchor),
//            
//            question5.topAnchor.constraint(equalTo: question4.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
//            question5.leftAnchor.constraint(equalTo: self.leftAnchor),
//            question5.rightAnchor.constraint(equalTo: self.rightAnchor),
//            
//            question6.topAnchor.constraint(equalTo: question5.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
//            question6.leftAnchor.constraint(equalTo: self.leftAnchor),
//            question6.rightAnchor.constraint(equalTo: self.rightAnchor),
//            
//            self.bottomAnchor.constraint(equalTo: question6.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL)
//            
//        ])
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
