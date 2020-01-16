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

class CGUViewController: ParentViewController, UIWebViewDelegate {

    fileprivate var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView.backgroundColor = .backgroundDefault
        self.titleBar.isHidden = true

        // Création d'un bouton "OK"
        let closeButton = CustomUIButton()
        closeButton.setTitle("Fermer", for: .normal)
        closeButton.setStyle(style: .defaultStyle)
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(closeButton)


        // Affichage du pdf des CGU
        guard let pathCGU = Bundle.main.url(forResource: "cgu", withExtension: "pdf") else {
            return
        }

        self.webView = UIWebView()
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.delegate = self
        self.webView.loadRequest(URLRequest(url: pathCGU))
        self.rootView.addSubview(self.webView)

        NSLayoutConstraint.activate([
            // bouton ok
            closeButton.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 5),
            closeButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -5),

            self.webView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.webView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor),
            self.webView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 5),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    @objc func closeModal() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webView.scrollView.minimumZoomScale = 1.0
        self.webView.scrollView.maximumZoomScale = 5.0
        self.webView.stringByEvaluatingJavaScript(from: "document.querySelector('meta[name=viewport]').setAttribute('content', 'user-scalable = 1;', false); ")
    }
}
