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

class PartnersViewController: ParentModalViewController {

    fileprivate var scrollView: UIScrollView!
    fileprivate var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleBar.isHidden = true

        self.scrollView = UIScrollView()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.rootView.addSubview(self.scrollView)

        self.contentView = UIView()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.contentView)

        let closeButton = CustomUIButton()
        closeButton.setTitle(Tools.getTranslate(key: "action_close"), for: .normal)
        closeButton.setStyle(style: .defaultStyle)
        closeButton.onClick = { [weak self] _ in
            guard let strongSelf = self else { return }

            strongSelf.dismiss(animated: true)
        }
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(closeButton)

        let text = CustomUILabel()
        let rgpdContent = Tools.getTranslate(key: "rgpd_first_content_1_line") + "\n\n" + Tools.getTranslate(key: "rgpd_first_content_2_line") + "\n\n" + Tools.getTranslate(key: "rgpd_first_content_3_line") + "\n\n" + Tools.getTranslate(key: "rgpd_first_content_4_line")
        text.text = rgpdContent
        text.setStyle(style: .bodyRegular)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .justified
        text.numberOfLines = 0
        self.contentView.addSubview(text)

        let partnersZone = UIView()
        partnersZone.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(partnersZone)
        
        let logoULR = self.createUIImageView(imageName: "logo_ulr")
        let logoCNRS = self.createUIImageView(imageName: "logo_cnrs")
        let logoLIENSs = self.createUIImageView(imageName: "logo_lienss")
        let logoL3i = self.createUIImageView(imageName: "logo_l3i")
        
        self.contentView.addSubview(logoULR)
        self.contentView.addSubview(logoCNRS)
        self.contentView.addSubview(logoLIENSs)
        self.contentView.addSubview(logoL3i)
        
        let separator = UIView()
        separator.backgroundColor = .black
        separator.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(separator)

        // Constraints CloseButton
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.rootView.topAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            closeButton.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING)
        ])

        // Constraints ScrollView
        NSLayoutConstraint.activate([

            self.scrollView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.scrollView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor),

            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.rootView.widthAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: partnersZone.bottomAnchor)
        ])

        // Constraints Text
        NSLayoutConstraint.activate([
            text.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constantes.PAGE_PADDING),
            text.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            text.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5),
            separator.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            separator.topAnchor.constraint(equalTo: text.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL)
        ])

        // Constraints images
        NSLayoutConstraint.activate([
            partnersZone.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            partnersZone.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Constantes.PAGE_PADDING),
            partnersZone.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Constantes.PAGE_PADDING),
            partnersZone.bottomAnchor.constraint(equalTo: logoL3i.bottomAnchor),

            logoULR.leftAnchor.constraint(equalTo: partnersZone.leftAnchor),
            logoULR.topAnchor.constraint(equalTo: partnersZone.topAnchor),
            logoULR.widthAnchor.constraint(equalTo: partnersZone.widthAnchor, multiplier: 0.45),
            logoULR.heightAnchor.constraint(equalTo: logoULR.widthAnchor),
            
            logoCNRS.rightAnchor.constraint(equalTo: partnersZone.rightAnchor),
            logoCNRS.topAnchor.constraint(equalTo: partnersZone.topAnchor),
            logoCNRS.widthAnchor.constraint(equalTo: partnersZone.widthAnchor, multiplier: 0.45),
            logoCNRS.heightAnchor.constraint(equalTo: logoCNRS.widthAnchor),
            
            logoLIENSs.leftAnchor.constraint(equalTo: partnersZone.leftAnchor),
            logoLIENSs.topAnchor.constraint(equalTo: logoULR.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            logoLIENSs.widthAnchor.constraint(equalTo: partnersZone.widthAnchor, multiplier: 0.45),
            logoLIENSs.heightAnchor.constraint(equalTo: logoLIENSs.widthAnchor),
            
            logoL3i.rightAnchor.constraint(equalTo: partnersZone.rightAnchor),
            logoL3i.topAnchor.constraint(equalTo: logoCNRS.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            logoL3i.widthAnchor.constraint(equalTo: partnersZone.widthAnchor, multiplier: 0.45),
            logoL3i.heightAnchor.constraint(equalTo: logoL3i.widthAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Permet de resize le content pour permettre le scroll
        scrollView.contentSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height + Constantes.FIELD_SPACING_VERTICAL)
    }

    fileprivate func createUIImageView(imageName: String) -> CustomUIImageView {
        let view = CustomUIImageView(frame: .zero)
        view.image = UIImage(named: imageName)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
