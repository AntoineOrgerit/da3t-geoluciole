//
//  FomulairePageControllerViewController.swift
//  Geoluciole
//
//  Created by RAYEZ Laurent on 20/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//
import Foundation
import UIKit

class FomulairePageController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var firstPage: FirstPageFormulaireController!
    var secondPage: SecondPageFormulaire!
    var thirdPage: ThirdPageFormulaire!
    var fourthPage: FourthPageFormulaire!
    var pageAffichable: [UIViewController] = [UIViewController]()
    var pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.firstPage = FirstPageFormulaireController()
        self.secondPage = SecondPageFormulaire()
        self.thirdPage = ThirdPageFormulaire()
        self.fourthPage = FourthPageFormulaire()

        if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
            pageAffichable.append(firstPage)
        } else {
            pageAffichable.append(secondPage)
        }

        firstPage.onNextButton = { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.firstPage.validationPage() {
                strongSelf.pageAffichable.append(strongSelf.secondPage)
                strongSelf.setViewControllers([strongSelf.secondPage], direction: .forward, animated: true, completion: nil)
            }
        }

        secondPage.onPreviousButton = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setViewControllers([strongSelf.firstPage], direction: .reverse, animated: true, completion: nil)


        }
        secondPage.onNextButton = {
            [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.secondPage.validationPage() {
                strongSelf.pageAffichable.append(strongSelf.thirdPage)
                strongSelf.setViewControllers([strongSelf.thirdPage], direction: .forward, animated: true, completion: nil)
            } else {
                print("error page 2")
            }
        }
        thirdPage.onPreviousButton = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setViewControllers([strongSelf.secondPage], direction: .reverse, animated: true, completion: nil)
        }
        thirdPage.onNextButton = {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.pageAffichable.append(strongSelf.fourthPage)
            strongSelf.setViewControllers([strongSelf.fourthPage], direction: .forward, animated: true, completion: nil)
        }

        self.fourthPage.prevPage = {
            [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.setViewControllers([strongSelf.thirdPage], direction: .reverse, animated: true, completion: nil)
        }

        fourthPage.onValider = {
            [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.fourthPage.validationPage() {
                UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_FORMULAIRE_REMPLI, value: true)
                strongSelf.dismiss(animated: true, completion: nil)

            }

        }

        //si le consentement de récupération des données du formulaire





        self.dataSource = self
        self.delegate = self

        if let firstViewController = pageAffichable.first {
            if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_REMPLI) {

            } else {
                setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            }

        }

    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = pageAffichable.firstIndex(of: viewController) else {
            return nil
        }
        if viewControllerIndex <= 0 {
            //return pageAffichable.last
            return nil
        } else {
            return pageAffichable[viewControllerIndex - 1]
            //return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageAffichable.firstIndex(of: viewController) else {
            return nil
        }
        if viewControllerIndex < (pageAffichable.count - 1) {
            return pageAffichable[viewControllerIndex + 1]
        } else {
            //return pageAffichable.first
            return nil
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentView = pageViewController.viewControllers![0]
        self.pageControl.currentPage = pageAffichable.firstIndex(of: currentView)!
    }

}
