//
//  FomulairePageControllerViewController.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 20/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//
import Foundation
import UIKit

class FomulairePageController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {


    var pageAffichable: [UIViewController] = [UIViewController]()
    var pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstPage = FirstPageFormulaireController()
        let secondPage = SecondPageFormulaire()
        let thirdPage = ThirdPageFormulaire()
        let fourthPage = FourthPageFormulaire()

        firstPage.onNextButton = { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.setViewControllers([secondPage], direction: .forward, animated: true, completion: nil)
        }

        secondPage.onPreviousButton = { [weak self] in
            guard let strSelf = self else {
                return
            }
            strSelf.setViewControllers([firstPage], direction: .reverse, animated: true, completion: nil)
        }
        secondPage.onNextButton = {
            [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.setViewControllers([thirdPage], direction: .forward, animated: true, completion: nil)
        }
        thirdPage.onPreviousButton = { [weak self] in
            guard let strSelf = self else {
                return
            }
            strSelf.setViewControllers([secondPage], direction: .reverse, animated: true, completion: nil)
        }
        thirdPage.onNextButton = {
            [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.setViewControllers([fourthPage], direction: .forward, animated: true, completion: nil)
        }
        
        fourthPage.prevPage = {
            [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.setViewControllers([thirdPage], direction: .reverse, animated: true, completion: nil)
        }

        //si le consentement de récupération des données du formulaire
        if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
            pageAffichable.append(firstPage)
        }
        pageAffichable.append(secondPage)
        pageAffichable.append(thirdPage)
        pageAffichable.append(fourthPage)

        self.dataSource = self
        self.delegate = self

        if let firstViewController = pageAffichable.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
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
            //return pageAffichable[viewControllerIndex - 1]
            return nil
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
