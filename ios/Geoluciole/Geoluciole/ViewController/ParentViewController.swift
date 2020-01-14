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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.removeAllViews()

        let subStatusBarView = UIView()
        subStatusBarView.backgroundColor = .backgroundTitleBar
        subStatusBarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(subStatusBarView)

        self.rootView = UIView(frame: .zero)
        self.rootView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.rootView)

        self.titleBar = TitleBarView(frame: .zero)
        self.titleBar.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.titleBar)

        NSLayoutConstraint.activate([
            subStatusBarView.topAnchor.constraint(equalTo: self.view.topAnchor),
            subStatusBarView.heightAnchor.constraint(equalToConstant: Tools.getStatusBarHeight()),
            subStatusBarView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            subStatusBarView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
            self.rootView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.view.rightAnchor),

            self.titleBar.widthAnchor.constraint(equalTo: self.rootView.widthAnchor),
            self.titleBar.heightAnchor.constraint(equalToConstant: Tools.getStatusBarHeight()),
            self.titleBar.topAnchor.constraint(equalTo: self.rootView.topAnchor),
            self.titleBar.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.titleBar.rightAnchor.constraint(equalTo: self.rootView.rightAnchor)
        ])

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ParentViewController.tappedRightButton))
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
