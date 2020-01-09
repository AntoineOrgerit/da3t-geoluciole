//
//  SettingsViewController.swift
//  Geoluciole
//
//  Created by local192 on 09/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rootView  = UIView(frame: CGRect(x: 0, y: Tools.getStatusBarHeight(), width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - Tools.getStatusBarHeight())))
        rootView.backgroundColor = .black
        self.view.addSubview(rootView)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Tools.getStatusBarHeight()))
        label.text = "SettingsViewController"
        label.backgroundColor = .red
        label.textAlignment = .center
        rootView.addSubview(label)
    }
}
