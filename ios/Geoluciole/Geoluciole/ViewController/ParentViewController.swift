//
//  ParentViewController.swift
//  Geoluciole
//
//  Created by local192 on 10/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class ParentViewController : UIViewController {
    
    fileprivate var titleBar: TitleBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.removeAllViews()
        
        self.titleBar = TitleBar(frame: .zero)
        self.titleBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.titleBar)
        
        NSLayoutConstraint.activate([
            self.titleBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 1),
            self.titleBar.heightAnchor.constraint(equalToConstant: Tools.getStatusBarHeight() * 2),
            self.titleBar.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
