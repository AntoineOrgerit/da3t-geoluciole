//    Copyright (c) 2020, Martin Allusse and Alexandre Baret and Jessy Barritault and Florian
//    Bertonnier and Lisa Fougeron and François Gréau and Thibaud Lambert and Antoine
//    Orgerit and Laurent Rayez
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

/// Classe permettant d'afficher le loader luciole
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
