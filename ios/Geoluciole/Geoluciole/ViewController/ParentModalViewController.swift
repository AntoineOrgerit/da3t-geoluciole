//Copyright (c) 2020, Martin Allusse and Alexandre Baret and Jessy Barritault and Florian
//Bertonnier and Lisa Fougeron and François Gréau and Thibaud Lambert and Antoine
//Orgerit and Laurent Rayez
//All rights reserved.
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:
//
//* Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//* Neither the name of the copyright holders nor the names of its
//  contributors may be used to endorse or promote products derived
//  from this software without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
//EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
//DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import Foundation
import UIKit

/// Identique à ParentVC sauf que ce VC ne n'a pas de tabBar
/// Il permet d'avoir la zone possible pour afficher les éléments
class ParentModalViewController: UIViewController {

    var titleBar: TitleBarView!
    var rootView: UIView!
    var userPrefs = UserPrefs.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.removeAllViews()

        let subStatusBarView = UIView()
        subStatusBarView.backgroundColor = .backgroundDefault
        subStatusBarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(subStatusBarView)

        self.rootView = UIView()
        self.rootView.backgroundColor = .white
        self.rootView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.rootView)

        self.titleBar = TitleBarView()
        self.titleBar.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.titleBar)

        NSLayoutConstraint.activate([
            subStatusBarView.topAnchor.constraint(equalTo: self.view.topAnchor),
            subStatusBarView.heightAnchor.constraint(equalToConstant: Tools.getStatusBarHeight()),
            subStatusBarView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            subStatusBarView.rightAnchor.constraint(equalTo: self.view.rightAnchor),

            self.rootView.topAnchor.constraint(equalTo: subStatusBarView.bottomAnchor),
            self.rootView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.rootView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.rootView.rightAnchor.constraint(equalTo: self.view.rightAnchor),

            self.titleBar.widthAnchor.constraint(equalTo: self.rootView.widthAnchor),
            self.titleBar.heightAnchor.constraint(equalToConstant: Tools.getStatusBarHeight() + 5),
            self.titleBar.topAnchor.constraint(equalTo: self.rootView.topAnchor),
            self.titleBar.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.titleBar.rightAnchor.constraint(equalTo: self.rootView.rightAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
        if Constantes.DEBUG {
            // Classe du VC deinit
            print(String(describing: type(of: self)) + " deinit !")
        }
    }
}
