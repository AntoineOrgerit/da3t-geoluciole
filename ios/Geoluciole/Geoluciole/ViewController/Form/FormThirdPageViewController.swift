//
//  FormThirdPageViewController.swift
//  Geoluciole
//
//  Created by Laurent RAYEZ on 20/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class FormThirdPageViewController: ParentModalViewController, ButtonsPrevNextDelegate {

    var onNextButton: (() -> Void)?
    var onPreviousButton: (() -> Void)?
    fileprivate var scrollView: UIScrollView!
    fileprivate var contentView: UIView!
    fileprivate var allFields = [Any]()
    var formData = [[String: Any]]()
    var formulaire: UIView!
    fileprivate var dropDown0: FormDropDownList!
    fileprivate var dropDown1: FormDropDownList!
    fileprivate var question1: FormYesNoQuestion!
    fileprivate var question2: FormYesNoQuestion!
    fileprivate var question3: FormYesNoQuestion!
    fileprivate var question4: FormYesNoQuestion!
    fileprivate var question5: FormYesNoQuestion!
    fileprivate var question6: FormYesNoQuestion!

    fileprivate var firstDropdownData = [
        Tools.getTranslate(key: "form_responses_whom_alone"),
        Tools.getTranslate(key: "form_responses_whom_family"),
        Tools.getTranslate(key: "form_responses_whom_friends"),
        Tools.getTranslate(key: "form_responses_whom_group")
    ]

    fileprivate var secondDropdownData = [
        Tools.getTranslate(key: "form_responses_transport_personal_car"),
        Tools.getTranslate(key: "form_responses_transport_carpool"),
        Tools.getTranslate(key: "form_responses_transport_bus"),
        Tools.getTranslate(key: "form_responses_transport_train"),
        Tools.getTranslate(key: "form_responses_transport_flight"),
        Tools.getTranslate(key: "form_responses_transport_boat"),
        Tools.getTranslate(key: "form_responses_transport_camping_car"),
        Tools.getTranslate(key: "form_responses_transport_cycling")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        let titre: FormTitlePage!
        
        if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
            titre = FormTitlePage(title: Tools.getTranslate(key: "form_title"), pageIndex: "3/4")
        } else {
            titre = FormTitlePage(title: Tools.getTranslate(key: "form_title_anonym"), pageIndex: "2/3")
        }
        
        titre.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(titre)

        // ScollView pour le texte
        self.scrollView = UIScrollView()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.scrollView)

        self.contentView = UIView()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false

        self.scrollView.addSubview(self.contentView)

        self.formulaire = self.createForm()
        self.formulaire.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(self.formulaire)

        let zoneButton = FabricCustomButton.createButton(type: .nextPrev)
        zoneButton.delegate = self
        zoneButton.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(zoneButton)

        //contrainte titre et bouttons
        NSLayoutConstraint.activate([
            titre.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            titre.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            titre.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),

            zoneButton.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            zoneButton.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            zoneButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
        ])

        //contraintes scrollview
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: titre.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.scrollView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            self.scrollView.bottomAnchor.constraint(equalTo: zoneButton.topAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),

            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])

        // Constraints form
        NSLayoutConstraint.activate([
            formulaire.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            formulaire.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            formulaire.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            formulaire.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    func getFormDat() -> [[String: Any]] {
        self.formData.append(["3": self.dropDown0.selectedValue])
        self.formData.append(["4": self.question1.selectedValue])
        self.formData.append(["5": self.question2.selectedValue])
        self.formData.append(["6": self.question3.selectedValue])
        self.formData.append(["7": self.question4.selectedValue])
        self.formData.append(["8": self.question5.selectedValue])
        self.formData.append(["9": self.question6.selectedValue])
        self.formData.append(["10": self.dropDown1.selectedValue])
        return formData

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Permet de resize le content pour permettre le scroll
        scrollView.contentSize = CGSize(width: self.contentView.bounds.width, height: self.contentView.bounds.height + Constantes.FIELD_SPACING_VERTICAL)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func boutonsPrevNext(boutonsPrevNext: ButtonsPrevNext, onNext: Bool) {
        self.onNextButton?()
    }

    func boutonsPrevNext(boutonsPrevNext: ButtonsPrevNext, onPrevious: Bool) {
        self.onPreviousButton?()
    }

    fileprivate func createForm() -> UIView {
        let v = UIStackView()
        v.axis = .vertical
        v.distribution = .equalSpacing
        v.translatesAutoresizingMaskIntoConstraints = false

        self.dropDown0 = FormDropDownList(title: Tools.getTranslate(key: "form_with_whom_title"), data: self.firstDropdownData)
        self.dropDown0.axis = .vertical
        self.dropDown0.translatesAutoresizingMaskIntoConstraints = false
        self.dropDown0.onResize = {
            self.scrollView.contentSize = CGSize(width: self.contentView.bounds.width, height: self.contentView.bounds.height + Constantes.FIELD_SPACING_VERTICAL)
        }
        self.allFields.append(self.dropDown0!)
        v.addArrangedSubview(self.dropDown0)

        self.question1 = FormYesNoQuestion(question: Tools.getTranslate(key: "presence_children"))
        self.question1.translatesAutoresizingMaskIntoConstraints = false
        self.allFields.append(self.question1!)
        v.addArrangedSubview(self.question1)

        self.question2 = FormYesNoQuestion(question: Tools.getTranslate(key: "presence_teens"))
        self.question2.translatesAutoresizingMaskIntoConstraints = false
        self.allFields.append(self.question2!)
        v.addArrangedSubview(self.question2)

        self.question3 = FormYesNoQuestion(question: Tools.getTranslate(key: "form_first_visit_title"))
        self.question3.translatesAutoresizingMaskIntoConstraints = false
        self.allFields.append(self.question3!)
        v.addArrangedSubview(self.question3)

        self.question4 = FormYesNoQuestion(question: Tools.getTranslate(key: "form_know_city_title"))
        self.question4.translatesAutoresizingMaskIntoConstraints = false
        self.allFields.append(self.question4!)
        v.addArrangedSubview(self.question4)

        self.question5 = FormYesNoQuestion(question: Tools.getTranslate(key: "form_more_five_times_title"))
        self.question5.translatesAutoresizingMaskIntoConstraints = false
        self.allFields.append(self.question5!)
        v.addArrangedSubview(self.question5)

        self.question6 = FormYesNoQuestion(question: Tools.getTranslate(key: "form_more_two_months_title"))
        self.question6.translatesAutoresizingMaskIntoConstraints = false
        self.allFields.append(self.question6!)
        v.addArrangedSubview(self.question6)

        self.dropDown1 = FormDropDownList(title: Tools.getTranslate(key: "form_transport_title"), data: self.secondDropdownData)
        self.dropDown1.axis = .vertical
        self.dropDown1.translatesAutoresizingMaskIntoConstraints = false
        self.dropDown1.onResize = {
            self.scrollView.contentSize = CGSize(width: self.contentView.bounds.width, height: self.contentView.bounds.height + Constantes.FIELD_SPACING_VERTICAL)
        }
        self.allFields.append(self.dropDown1!)
        v.addArrangedSubview(self.dropDown1)

        NSLayoutConstraint.activate([
            self.dropDown0.topAnchor.constraint(equalTo: v.topAnchor),
            self.dropDown0.leftAnchor.constraint(equalTo: v.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.dropDown0.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -Constantes.PAGE_PADDING),

            self.question1.topAnchor.constraint(equalTo: dropDown0.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.question1.leftAnchor.constraint(equalTo: v.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.question1.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -Constantes.PAGE_PADDING),

            self.question2.topAnchor.constraint(equalTo: self.question1.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.question2.leftAnchor.constraint(equalTo: v.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.question2.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -Constantes.PAGE_PADDING),

            self.question3.topAnchor.constraint(equalTo: self.question2.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.question3.leftAnchor.constraint(equalTo: v.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.question3.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -Constantes.PAGE_PADDING),

            self.question4.topAnchor.constraint(equalTo: self.question3.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.question4.leftAnchor.constraint(equalTo: v.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.question4.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -Constantes.PAGE_PADDING),

            self.question5.topAnchor.constraint(equalTo: self.question4.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.question5.leftAnchor.constraint(equalTo: v.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.question5.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -Constantes.PAGE_PADDING),

            self.question6.topAnchor.constraint(equalTo: self.question5.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.question6.leftAnchor.constraint(equalTo: v.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.question6.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -Constantes.PAGE_PADDING),

            self.dropDown1.topAnchor.constraint(equalTo: self.question6.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.dropDown1.leftAnchor.constraint(equalTo: v.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.dropDown1.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -Constantes.PAGE_PADDING)
        ])

        return v
    }

    func validationPage() -> Bool {
        for field in allFields {
            if field is FormYesNoQuestion {
                let r = (field as! FormYesNoQuestion).isValid
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
