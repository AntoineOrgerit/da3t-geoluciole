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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootView.backgroundColor = .backgroundDefault
        self.titleBar.isHidden = true

        // Création d'un bouton "OK"
        let okBtn = UIButton()
        okBtn.setTitle("OK", for: .normal)
        okBtn.setTitleColor(.white, for: .normal)
        okBtn.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        okBtn.translatesAutoresizingMaskIntoConstraints = false

        self.rootView.addSubview(okBtn)


        // Affichage du pdf des CGU
        guard let pathCGU = Bundle.main.url(forResource: "cgu", withExtension: "pdf") else {
            return
        }
        
        let webView = UIWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.delegate = self
        webView.loadRequest(URLRequest(url: pathCGU))
        self.rootView.addSubview(webView)

        NSLayoutConstraint.activate([
            // bouton ok
            okBtn.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: 10),
            okBtn.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -10),
            
            webView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            webView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor),
            webView.topAnchor.constraint(equalTo: okBtn.bottomAnchor, constant: 10),
            webView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor)
        ])
    }

    @objc func closeModal() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
