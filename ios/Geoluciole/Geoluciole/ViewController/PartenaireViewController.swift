//
//  PartenaireViewController.swift
//  Geoluciole
//
//  Created by Laurent RAYEZ on 15/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class PartenaireViewController: ParentViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
    
    let mytableView = UITableViewController(style: UITableView.Style.grouped )
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleBar.isHidden = true
        
        
        let laboImage = createImage(name: "logo_l3i")
        let univImageView = createImage(name: "logo_ULR")
        //let liensImageView = createImage(name: <#T##String#>)

        self.rootView.addSubview(laboImage)
        self.rootView.addSubview(univImageView)
        //self.rootView.addSubview(liensImageView)

        NSLayoutConstraint.activate([

        ])
    }

    func createImage(name: String) -> UIImageView {
        let image = UIImage(named: name)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
