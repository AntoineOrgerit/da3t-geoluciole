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
        
        self.titleBar = TitleBar(frame: CGRect(x: 0, y: 0, width: Tools.getScreenWidth(), height: (Tools.getStatusBarHeight() * 2)))
        self.view.addSubview(self.titleBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
