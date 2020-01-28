//
//  UIViewExtension.swift
//  Geoluciole
//
//  Created by Thibaud LAMBERT on 12/01/2020.
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

    func removeAllViews(removeTitleBar: Bool = false) {
        for view in self.subviews {
            if view.isKind(of: TitleBarView.self) &&  removeTitleBar {
                view.removeFromSuperview()
            } else if !view.isKind(of: TitleBarView.self){
                view.removeFromSuperview()
            }
            
        }
    }
}
