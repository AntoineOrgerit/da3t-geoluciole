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

class BadgesCollectionViewCell: UICollectionViewCell {

    fileprivate var iv: CustomUIImageView!
    var idBadge: Int!
    var onClick: ((BadgesCollectionViewCell) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.iv = CustomUIImageView(frame: .zero)
        self.iv.image = UIImage(named: "no-img")
        self.iv.contentMode = . scaleAspectFit
        self.iv.translatesAutoresizingMaskIntoConstraints = false
        self.iv.onClick = { [weak self] _ in
            guard let strongSelf = self else { return }

            strongSelf.onClick?(strongSelf)
        }
        self.contentView.addSubview(self.iv)

        NSLayoutConstraint.activate([
            self.iv.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.iv.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.iv.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.iv.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setImage(name: String) {
        self.iv.image = UIImage(named: name) ?? UIImage(named: "no-img")
    }
}
