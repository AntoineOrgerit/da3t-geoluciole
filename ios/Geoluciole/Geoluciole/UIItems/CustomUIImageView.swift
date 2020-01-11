//
//  CustomUIImageView.swift
//  Geoluciole
//
//  Created by local192 on 10/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class CustomUIImageView: UIImageView, UIGestureRecognizerDelegate {
    
    var onClick: ((CustomUIImageView) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CustomUIImageView.touchOnUIImageView))
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.delegate = self
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc fileprivate func touchOnUIImageView() {
        self.onClick?(self)
    }
}
