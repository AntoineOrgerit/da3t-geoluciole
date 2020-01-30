//    Copyright (c) 2020, La Rochelle Université
//    All rights reserved.
//    Redistribution and use in source and binary forms, with or without
//    modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright
//      notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//    * Neither the name of the University of California, Berkeley nor the
//      names of its contributors may be used to endorse or promote products
//      derived from this software without specific prior written permission.
//
//    THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
//    EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//    DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
//    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import Foundation
import UIKit

class CustomUIButton: UIButton {

    var onClick: ((CustomUIButton) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18)
        self.addTarget(self, action: #selector(CustomUIButton.touchOnUIButton), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /// Applique le style définition en paramètre (énumération)
    func setStyle(style: ButtonStyle) {

        switch style {
        case .settingLight:
            self.backgroundColor = .white
            self.layer.borderColor = UIColor.settingsButtonDark.cgColor
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 5
            self.setTitleColor(.settingsButtonDark, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        case .settingDark:
            self.backgroundColor = .settingsButtonDark
            self.layer.borderColor = UIColor.settingsButtonDark.cgColor
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 5
            self.setTitleColor(.settingsButtonLight, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        case .disabled:
            self.backgroundColor = .disabledButton
            self.layer.borderColor = UIColor.disabledButton.cgColor
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 5
            self.setTitleColor(.white, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        case .active:
            self.backgroundColor = .activeButton
            self.layer.borderColor = UIColor.activeButton.cgColor
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 5
            self.setTitleColor(.white, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        case .delete:
            self.backgroundColor = .delete
            self.layer.borderColor = UIColor.delete.cgColor
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 5
            self.setTitleColor(.white, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        case .defaultStyle:
            self.backgroundColor = .white
            self.layer.borderColor = UIColor.settingsButtonDark.cgColor
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 5
            self.setTitleColor(.settingsButtonDark, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
        case .dateField:
            self.backgroundColor = .activeButton
            self.layer.borderColor = UIColor.activeButton.cgColor
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 5
            self.setTitleColor(.white, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        }
    }

    @objc fileprivate func touchOnUIButton() {
        self.onClick?(self)
    }
}
