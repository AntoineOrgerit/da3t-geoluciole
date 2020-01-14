//
//  UIViewExtension.swift
//  Geoluciole
//
//  Created by local192 on 12/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    func setDefaultBoxStyle() {
        self.layer.cornerRadius = 5
    }

    func removeAllViews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}
