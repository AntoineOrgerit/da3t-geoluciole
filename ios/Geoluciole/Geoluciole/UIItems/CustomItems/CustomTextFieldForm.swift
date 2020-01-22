//
//  CustomTextFieldForm.swift
//  Geoluciole
//
//  Created by ai.cgi niort on 21/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class CustomTextFieldForm: UITextField {
    
    func setUpTextField(text: String) {
        
        self.placeholder = text
        self.textColor = .black
        self.textAlignment = .left
        self.backgroundColor = .white
        
    }
    
}
