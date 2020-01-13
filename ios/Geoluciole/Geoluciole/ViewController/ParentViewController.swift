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

    var titleBar: TitleBar = TitleBar(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.view.removeAllViews()

        //self.titleBar = TitleBar(frame: .zero)
        self.titleBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.titleBar)

        NSLayoutConstraint.activate([
            self.titleBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 1),
            self.titleBar.heightAnchor.constraint(equalToConstant: Tools.getStatusBarHeight() * 2),
            self.titleBar.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ParentViewController.tappedRightButton))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

        let rightLeft = UISwipeGestureRecognizer(target: self, action: #selector(ParentViewController.tappedLeftButton))
        rightLeft.direction = .right
        self.view.addGestureRecognizer(rightLeft)
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
