//
//  ParentModalViewController.swift
//  Geoluciole
//
//  Created by Thibaud LAMBERT on 17/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class ParentModalViewController: UIViewController {

    var titleBar: TitleBarView!
    var rootView: UIView!
    var userPrefs = UserPrefs.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.removeAllViews()

        let subStatusBarView = UIView()
        subStatusBarView.backgroundColor = .backgroundDefault
        subStatusBarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(subStatusBarView)

        self.rootView = UIView()
        self.rootView.backgroundColor = .white
        self.rootView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.rootView)

        self.titleBar = TitleBarView()
        self.titleBar.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.titleBar)

        NSLayoutConstraint.activate([
            subStatusBarView.topAnchor.constraint(equalTo: self.view.topAnchor),
            subStatusBarView.heightAnchor.constraint(equalToConstant: Tools.getStatusBarHeight()),
            subStatusBarView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            subStatusBarView.rightAnchor.constraint(equalTo: self.view.rightAnchor),

            self.rootView.topAnchor.constraint(equalTo: subStatusBarView.bottomAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.view.rightAnchor),

            self.titleBar.widthAnchor.constraint(equalTo: self.rootView.widthAnchor),
            self.titleBar.heightAnchor.constraint(equalToConstant: Tools.getStatusBarHeight() + 5),
            self.titleBar.topAnchor.constraint(equalTo: self.rootView.topAnchor),
            self.titleBar.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.titleBar.rightAnchor.constraint(equalTo: self.rootView.rightAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
