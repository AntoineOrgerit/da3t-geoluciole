//
//  FirstViewController.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var niveau: UILabel!
    @IBOutlet var switchData: UISwitch!
    @IBOutlet var progressBar: UIProgressView!
    
    let param = Params.getInstance().param
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let send = param.bool(forKey: "send_data")
        switchData.setOn(send, animated: true)
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let send = param.bool(forKey: "send_data")
        switchData.setOn(send, animated: true)
        //self.tabBarController?.delegate = self as? UITabBarControllerDelegate
    }
    
    @IBAction func switchSender(sender: UISwitch){
        param.set(sender.isOn, forKey: "send_data")
    }
    
    

}

