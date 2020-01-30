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
import PDFKit

class CGUViewController: ParentModalViewController, UIWebViewDelegate {

    fileprivate var webView: UIWebView!
    fileprivate var wrapContent: UIView!
    fileprivate var loader: LoaderView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Affichage du pdf des CGU
        guard let pathCGU = Bundle.main.url(forResource: "cgu", withExtension: "pdf") else {
            return
        }

        self.titleBar.isHidden = true

        // Création d'un bouton "Femer"
        let closeButton = CustomUIButton()
        closeButton.setTitle(Tools.getTranslate(key: "action_close"), for: .normal)
        closeButton.setStyle(style: .defaultStyle)
        closeButton.onClick = { [weak self] _ in
            guard let strongSelf = self else { return }

            strongSelf.dismiss(animated: true)
        }
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(closeButton)

        self.wrapContent = UIView()
        self.wrapContent.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.wrapContent)

        self.webView = UIWebView()
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.delegate = self
        self.webView.loadRequest(URLRequest(url: pathCGU))
        self.webView.scrollView.minimumZoomScale = 1.0
        self.webView.scrollView.maximumZoomScale = 5.0
        self.webView.scalesPageToFit = true
        self.wrapContent.addSubview(self.webView)

        self.loader = LoaderView(frame: .zero)
        self.loader.translatesAutoresizingMaskIntoConstraints = false
        self.wrapContent.addSubview(self.loader)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 5),
            closeButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -5),

            self.wrapContent.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.wrapContent.rightAnchor.constraint(equalTo: self.rootView.rightAnchor),
            self.wrapContent.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 5),
            self.wrapContent.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor),

            self.webView.leftAnchor.constraint(equalTo: self.wrapContent.leftAnchor),
            self.webView.rightAnchor.constraint(equalTo: self.wrapContent.rightAnchor),
            self.webView.topAnchor.constraint(equalTo: self.wrapContent.topAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.wrapContent.bottomAnchor),

            self.loader.centerXAnchor.constraint(equalTo: self.wrapContent.centerXAnchor),
            self.loader.centerYAnchor.constraint(equalTo: self.wrapContent.centerYAnchor),
            self.loader.widthAnchor.constraint(equalToConstant: Constantes.LOADER_SIZE),
            self.loader.heightAnchor.constraint(equalTo: self.loader.widthAnchor)
        ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loader.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        self.loader.startAnimating()
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.loader.stopAnimating()
    }
}
