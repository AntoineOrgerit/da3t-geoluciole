//
//  CGUViewController.swift
//  Geoluciole
//
//  Created by Alexandre BARET on 15/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit
import PDFKit

class CGUViewController: ParentModalViewController, UIWebViewDelegate {

    fileprivate var webView: UIWebView!
    fileprivate var wrapContent: UIView!
    fileprivate var loader: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Affichage du pdf des CGU
        guard let pathCGU = Bundle.main.url(forResource: "cgu", withExtension: "pdf") else {
            return
        }

        self.titleBar.isHidden = true

        // Création d'un bouton "OK"
        let closeButton = CustomUIButton()
        closeButton.setTitle("Fermer", for: .normal)
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

        self.loader = UIActivityIndicatorView()
        self.loader.color = .backgroundDefault
        self.loader.hidesWhenStopped = true
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
            self.loader.centerYAnchor.constraint(equalTo: self.wrapContent.centerYAnchor)
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
