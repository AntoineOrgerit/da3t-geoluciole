//    Copyright (c) 2020, La Rochelle Université
//    All rights reserved.
//    Redistribution and use in source and binary forms, with or without
//    modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright
//      notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//    * Neither the name of the University of California, Berkeley nor the
//      names of its contributors may be used to endorse or promote products
//      derived from this software without specific prior written permission.
//
//    THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
//    EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//    DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
//    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import Foundation
import UIKit

// Permet d'obtenir la zone safe d'affichage pour l'application
class ParentViewController: UIViewController {

    var titleBar: TitleBarView!
    var rootView: UIView!
    var userPrefs = UserPrefs.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Permet de forcer le thème clair
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }

        self.view.removeAllViews()

        // Cet élément permet de colorer la statusBar
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

        // Ces swipes permettent de glisser d'une vue à l'autre
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
