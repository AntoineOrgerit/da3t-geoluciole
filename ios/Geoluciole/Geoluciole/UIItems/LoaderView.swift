//
//  LoaderView.swift
//  Geoluciole
//
//  Created by Thibaud LAMBERT on 22/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class LoaderView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.animationImages = [
            UIImage(named: "loader_0")!,
            UIImage(named: "loader_45")!,
            UIImage(named: "loader_90")!,
            UIImage(named: "loader_135")!,
            UIImage(named: "loader_180")!,
            UIImage(named: "loader_225")!,
            UIImage(named: "loader_270")!,
            UIImage(named: "loader_315")!,
            UIImage(named: "loader_0")!,
            UIImage(named: "loader_45")!,
            UIImage(named: "loader_90")!,
            UIImage(named: "loader_135")!,
            UIImage(named: "loader_180")!,
            UIImage(named: "loader_225")!,
            UIImage(named: "loader_270")!,
            UIImage(named: "loader_315")!
        ]
        self.contentMode = .scaleAspectFill
        self.animationDuration = TimeInterval(Double(self.animationImages!.count) / 30.0)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func startAnimating() {
        self.isHidden = false
        super.startAnimating()
    }
    
    override func stopAnimating() {
        super.stopAnimating()
        self.isHidden = true
    }
}
