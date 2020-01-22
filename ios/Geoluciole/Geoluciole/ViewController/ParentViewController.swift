//
//  ParentViewController.swift
//  Geoluciole
//
//  Created by local192 on 10/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class ParentViewController: UIViewController {

    var titleBar: TitleBarView!
    var rootView: UIView!
    var userPrefs = UserPrefs.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }

        self.view.removeAllViews()

        let subStatusBarView = UIView()
        subStatusBarView.backgroundColor = .backgroundDefault
        subStatusBarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(subStatusBarView)

        self.rootView = UIView()
        self.rootView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.rootView)

        self.titleBar = TitleBarView()
        self.titleBar.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.titleBar)

        // Constraints for iOS 11 and later
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                subStatusBarView.topAnchor.constraint(equalTo: self.view.topAnchor),
                subStatusBarView.heightAnchor.constraint(equalToConstant: Tools.getStatusBarHeight()),
                subStatusBarView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                subStatusBarView.rightAnchor.constraint(equalTo: self.view.rightAnchor),

                self.rootView.topAnchor.constraint(equalTo: subStatusBarView.bottomAnchor),
                self.rootView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                self.rootView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                self.rootView.rightAnchor.constraint(equalTo: self.view.rightAnchor),

                self.titleBar.widthAnchor.constraint(equalTo: self.rootView.widthAnchor),
                self.titleBar.heightAnchor.constraint(equalToConstant: Tools.getStatusBarHeight() + 5),
                self.titleBar.topAnchor.constraint(equalTo: self.rootView.topAnchor),
                self.titleBar.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
                self.titleBar.rightAnchor.constraint(equalTo: self.rootView.rightAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                subStatusBarView.topAnchor.constraint(equalTo: self.view.topAnchor),
                subStatusBarView.heightAnchor.constraint(equalToConstant: Tools.getStatusBarHeight()),
                subStatusBarView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                subStatusBarView.rightAnchor.constraint(equalTo: self.view.rightAnchor),

                self.rootView.topAnchor.constraint(equalTo:subStatusBarView.bottomAnchor),
                // On retire 49 car c'est la taille de la TabBar
                self.rootView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -49),
                self.rootView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                self.rootView.rightAnchor.constraint(equalTo: self.view.rightAnchor),

                self.titleBar.widthAnchor.constraint(equalTo: self.rootView.widthAnchor),
                self.titleBar.heightAnchor.constraint(equalToConstant: Tools.getStatusBarHeight() + 5),
                self.titleBar.topAnchor.constraint(equalTo: self.rootView.topAnchor),
                self.titleBar.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
                self.titleBar.rightAnchor.constraint(equalTo: self.rootView.rightAnchor)
            ])
        }

        let swipeLeft = UISwipeGestureRecognizer(target: self, action:
            #selector(ParentViewController.tappedRightButton))
        swipeLeft.direction = .left
        self.rootView.addGestureRecognizer(swipeLeft)

        let rightLeft = UISwipeGestureRecognizer(target: self, action: #selector(ParentViewController.tappedLeftButton))
        rightLeft.direction = .right
        self.rootView.addGestureRecognizer(rightLeft)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc fileprivate func tappedRightButton() {
        if let tabBarController = self.tabBarController {
            let selectedIndex = tabBarController.selectedIndex
            tabBarController.selectedIndex = selectedIndex + 1
        }
    }

    @objc fileprivate func tappedLeftButton() {
        if let tabBarController = self.tabBarController {
            let selectedIndex = tabBarController.selectedIndex
            tabBarController.selectedIndex = selectedIndex - 1
        }
    }
}
