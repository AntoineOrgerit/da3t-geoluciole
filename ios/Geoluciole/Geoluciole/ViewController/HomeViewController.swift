//
//  FirstViewController.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import UIKit

class HomeViewController: ParentViewController {

    @IBOutlet var niveau: UILabel!
    @IBOutlet var switchData: UISwitch!
    @IBOutlet var progressBar: UIProgressView!

    let param = Params.getInstance().param

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let send = param.bool(forKey: "send_data")
        switchData.setOn(send, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let send = param.bool(forKey: "send_data")
        switchData.setOn(send, animated: true)
    }

    @IBAction func switchSender(sender: UISwitch) {
        param.set(sender.isOn, forKey: "send_data")
    }
}

