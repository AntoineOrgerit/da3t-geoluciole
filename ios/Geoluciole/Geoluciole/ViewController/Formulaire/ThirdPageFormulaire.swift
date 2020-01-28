//
//  ThirdPageFormulaire.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 20/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class ThirdPageFormulaire: ParentModalViewController, BoutonsPrevNextDelegate {

    var onNextButton: (() -> Void)?
    var onPreviousButton: (() -> Void)?
    fileprivate var scrollView: UIScrollView!
    fileprivate var contentView: UIView!
    fileprivate var allFields = [Any]()

    fileprivate var firstDropdownData = [Tools.getTranslate(key: "form_responses_whom_alone"),
                                         Tools.getTranslate(key: "form_responses_whom_family"),
                                         Tools.getTranslate(key: "form_responses_whom_friends"),
                                         Tools.getTranslate(key: "form_responses_whom_group")]

    fileprivate var secondDropdownData = [Tools.getTranslate(key: "form_responses_transport_personal_car"),
                                          Tools.getTranslate(key: "form_responses_transport_carpool"),
                                          Tools.getTranslate(key: "form_responses_transport_bus"),
                                          Tools.getTranslate(key: "form_responses_transport_train"),
                                          Tools.getTranslate(key: "form_responses_transport_flight"),
                                          Tools.getTranslate(key: "form_responses_transport_boat"),
                                          Tools.getTranslate(key: "form_responses_transport_camping_car"),
                                          Tools.getTranslate(key: "form_responses_transport_cycling")]
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Permet de resize le content pour permettre le scroll
        scrollView.contentSize = CGSize(width: self.contentView.bounds.width, height: self.contentView.bounds.height + Constantes.FIELD_SPACING_VERTICAL)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let titre3 = CustomTitleForm(titre: "", page: "")
        titre3.translatesAutoresizingMaskIntoConstraints = false

        let aff_page: String
        if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
            aff_page = "3/4"
        } else {
            aff_page = "2/3"
        }

        titre3.setuptitle(title: Tools.getTranslate(key: "form_title"), pg: aff_page)
        self.rootView.addSubview(titre3)

        // ScollView pour le texte
        self.scrollView = UIScrollView()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.scrollView)

        self.contentView = UIView()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false

        self.scrollView.addSubview(self.contentView)

        let formulaire = self.createForm()
        formulaire.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(formulaire)

        let zoneButton = FabCustomButton.createButton(type: .nextPrev)
        zoneButton.delegate = self
        zoneButton.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(zoneButton)

        //contrainte titre et bouttons
        NSLayoutConstraint.activate([

            titre3.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            titre3.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            titre3.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),

            zoneButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            zoneButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            zoneButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),

        ])

        //contraintes scrollview
        NSLayoutConstraint.activate([

            self.scrollView.topAnchor.constraint(equalTo: titre3.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.scrollView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.scrollView.bottomAnchor.constraint(equalTo: zoneButton.topAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),


            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
//            self.contentView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor, constant: -Constantes.PAGE_PADDING),
//            self.contentView.bottomAnchor.constraint(equalTo: formulaire.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            formulaire.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            formulaire.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            formulaire.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            formulaire.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
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

    fileprivate func createForm() -> UIView {
        let v = UIStackView()
        v.axis = .vertical
        v.distribution = .equalSpacing
        v.translatesAutoresizingMaskIntoConstraints = false

        let dropDown0 = FormDropDownList(title: Tools.getTranslate(key: "form_with_whom_title"), data: self.firstDropdownData)
        dropDown0.axis = .vertical
        dropDown0.translatesAutoresizingMaskIntoConstraints = false
        dropDown0.onResize = {
            self.scrollView.contentSize = CGSize(width: self.contentView.bounds.width, height: self.contentView.bounds.height + Constantes.FIELD_SPACING_VERTICAL)
        }
        self.allFields.append(dropDown0)
        v.addArrangedSubview(dropDown0)

        let question1 = CustomQuestionForm(quest: Tools.getTranslate(key: "presence_children"))
        question1.translatesAutoresizingMaskIntoConstraints = false
        self.allFields.append(question1)
        v.addArrangedSubview(question1)

        let question2 = CustomQuestionForm(quest: Tools.getTranslate(key: "presence_teens"))
        question2.translatesAutoresizingMaskIntoConstraints = false
        self.allFields.append(question2)
        v.addArrangedSubview(question2)

        let question3 = CustomQuestionForm(quest: Tools.getTranslate(key: "form_first_visit_title"))
        question3.translatesAutoresizingMaskIntoConstraints = false
        self.allFields.append(question3)
        v.addArrangedSubview(question3)

        let question4 = CustomQuestionForm(quest: Tools.getTranslate(key: "form_know_city_title"))
        question4.translatesAutoresizingMaskIntoConstraints = false
        self.allFields.append(question4)
        v.addArrangedSubview(question4)

        let question5 = CustomQuestionForm(quest: Tools.getTranslate(key: "form_more_five_times_title"))
        question5.translatesAutoresizingMaskIntoConstraints = false
        self.allFields.append(question5)
        v.addArrangedSubview(question5)

        let question6 = CustomQuestionForm(quest: Tools.getTranslate(key: "form_more_two_months_title"))
        question6.translatesAutoresizingMaskIntoConstraints = false
        self.allFields.append(question6)
        v.addArrangedSubview(question6)

        let dropDown1 = FormDropDownList(title: Tools.getTranslate(key: "form_transport_title"), data: self.secondDropdownData)
        dropDown1.axis = .vertical
        dropDown1.translatesAutoresizingMaskIntoConstraints = false
        dropDown1.onResize = {
            self.scrollView.contentSize = CGSize(width: self.contentView.bounds.width, height: self.contentView.bounds.height + Constantes.FIELD_SPACING_VERTICAL)
        }
        self.allFields.append(dropDown1)
        v.addArrangedSubview(dropDown1)

        NSLayoutConstraint.activate([
            dropDown0.topAnchor.constraint(equalTo: v.topAnchor),
            dropDown0.leftAnchor.constraint(equalTo: v.leftAnchor, constant: Constantes.PAGE_PADDING),
            dropDown0.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -Constantes.PAGE_PADDING),

            question1.topAnchor.constraint(equalTo: dropDown0.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            question1.leftAnchor.constraint(equalTo: v.leftAnchor, constant: Constantes.PAGE_PADDING),
            question1.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -Constantes.PAGE_PADDING),

            question2.topAnchor.constraint(equalTo: question1.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            question2.leftAnchor.constraint(equalTo: v.leftAnchor, constant: Constantes.PAGE_PADDING),
            question2.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -Constantes.PAGE_PADDING),

            question3.topAnchor.constraint(equalTo: question2.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            question3.leftAnchor.constraint(equalTo: v.leftAnchor, constant: Constantes.PAGE_PADDING),
            question3.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -Constantes.PAGE_PADDING),

            question4.topAnchor.constraint(equalTo: question3.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            question4.leftAnchor.constraint(equalTo: v.leftAnchor, constant: Constantes.PAGE_PADDING),
            question4.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -Constantes.PAGE_PADDING),

            question5.topAnchor.constraint(equalTo: question4.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            question5.leftAnchor.constraint(equalTo: v.leftAnchor, constant: Constantes.PAGE_PADDING),
            question5.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -Constantes.PAGE_PADDING),

            question6.topAnchor.constraint(equalTo: question5.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            question6.leftAnchor.constraint(equalTo: v.leftAnchor, constant: Constantes.PAGE_PADDING),
            question6.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -Constantes.PAGE_PADDING),

            dropDown1.topAnchor.constraint(equalTo: question6.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            dropDown1.leftAnchor.constraint(equalTo: v.leftAnchor, constant: Constantes.PAGE_PADDING),
            dropDown1.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -Constantes.PAGE_PADDING)
        ])

        return v
    }

    func validationPage() -> Bool {
        for field in allFields {
            if field is CustomQuestionForm {
                let r = (field as! CustomQuestionForm).isValid
                if !r {
                    return false
                }
            } else if field is FormDropDownList {
                let r = (field as! FormDropDownList).isValid
                if !r {
                    return false
                }
            }
        }
        
        return true
    }
}
