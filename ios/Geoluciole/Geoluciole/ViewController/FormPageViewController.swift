//
//  FormPageViewController.swift
//  Geoluciole
//
//  Created by Laurent RAYEZ on 20/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//
import Foundation
import UIKit


/// Classe permettant de gérer les pages de formulaire
class FormPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    fileprivate var formAnswers = [[String: Any]]()
    fileprivate var formInfoGen = [String: Any]()
    fileprivate var firstPage: FormFirstPageViewController!
    fileprivate var secondPage: FormSecondPageViewController!
    fileprivate var thirdPage: FormThirdPageViewController!
    fileprivate var fourthPage: FormFourthPageViewController!
    fileprivate var displayablePages: [UIViewController] = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.firstPage = FormFirstPageViewController()
        self.secondPage = FormSecondPageViewController()
        self.thirdPage = FormThirdPageViewController()
        self.fourthPage = FormFourthPageViewController()

        if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
            self.displayablePages.append(self.firstPage)
        } else {
            self.displayablePages.append(self.secondPage)
        }

        self.firstPage.onNextButton = { [weak self] in
            guard let strongSelf = self else { return }

            if strongSelf.firstPage.validationPage() {
                strongSelf.formInfoGen = strongSelf.firstPage.getFormDataInfoGen()
                strongSelf.displayablePages.append(strongSelf.secondPage)
                strongSelf.setViewControllers([strongSelf.secondPage], direction: .forward, animated: true, completion: nil)
            } else {
                var s = ToastStyle()
                s.backgroundColor = .red
                s.messageColor = .white
                strongSelf.firstPage.rootView.makeToast(Tools.getTranslate(key: "toast_form_error"), duration: 3, style: s)
            }
        }

        self.secondPage.onPreviousButton = { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.setViewControllers([strongSelf.firstPage], direction: .reverse, animated: true, completion: nil)
        }

        self.secondPage.onNextButton = {
            [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.secondPage.validationPage() {
                strongSelf.formAnswers.append(strongSelf.secondPage.getFormDat())
                strongSelf.displayablePages.append(strongSelf.thirdPage)
                strongSelf.setViewControllers([strongSelf.thirdPage], direction: .forward, animated: true, completion: nil)
            } else {
                var s = ToastStyle()
                s.backgroundColor = .red
                s.messageColor = .white
                strongSelf.secondPage.rootView.makeToast(Tools.getTranslate(key: "toast_form_error"), duration: 3, style: s)
            }
        }

        self.thirdPage.onPreviousButton = { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.setViewControllers([strongSelf.secondPage], direction: .reverse, animated: true, completion: nil)
        }

        self.thirdPage.onNextButton = { [weak self] in
            guard let strongSelf = self else { return }

            if strongSelf.thirdPage.validationPage() {
                strongSelf.formAnswers.append(strongSelf.thirdPage.getFormDat())
                strongSelf.displayablePages.append(strongSelf.fourthPage)
                strongSelf.setViewControllers([strongSelf.fourthPage], direction: .forward, animated: true, completion: nil)
            } else {
                var s = ToastStyle()
                s.backgroundColor = .red
                s.messageColor = .white
                strongSelf.thirdPage.rootView.makeToast(Tools.getTranslate(key: "toast_form_error"), duration: 3, style: s)
            }
        }

        self.fourthPage.prevPage = { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.setViewControllers([strongSelf.thirdPage], direction: .reverse, animated: true, completion: nil)
        }

        self.fourthPage.onValidate = {
            [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.fourthPage.validationPage() {
                UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_FORMULAIRE_REMPLI, value: true)
                let msg = ElasticSearchAPI.getInstance().generateMessage(content: strongSelf.formAnswers, needBulk: true)

                let msg2 = ElasticSearchAPI.getInstance().generateMessage(content: [strongSelf.formInfoGen], needBulk: true)
                
                strongSelf.dismiss(animated: true, completion: nil)
            } else {
                var s = ToastStyle()
                s.backgroundColor = .red
                s.messageColor = .white
                strongSelf.fourthPage.rootView.makeToast(Tools.getTranslate(key: "toast_form_error"), duration: 3, style: s)
            }
        }

        // TODO: POURQUOI CE COMMENTAIRE ?
        // Si le consentement de récupération des données du formulaire
        self.dataSource = self
        self.delegate = self

        if let firstViewController = displayablePages.first {
            if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_REMPLI) {
                // TODO: POURQUOI C'EST VIDE ICI ?
            } else {
                setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            }
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // Blocage des swipes
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // Blocage des swipes
        return nil
    }

}
