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


/// Classe permettant de gérer les pages de formulaire
class FormPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    fileprivate var formAnswers = [[String: Any]]()
    fileprivate var formInfoGen = [String: Any]()
    fileprivate var firstPage: FormFirstPageViewController!
    fileprivate var secondPage: FormSecondPageViewController!
    fileprivate var thirdPage: FormThirdPageViewController!
    fileprivate var fourthPage: FormFourthPageViewController!
    fileprivate var displayablePages: [UIViewController] = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.firstPage = FormFirstPageViewController()
        self.secondPage = FormSecondPageViewController()
        self.thirdPage = FormThirdPageViewController()
        self.fourthPage = FormFourthPageViewController()

        if UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT) {
            self.displayablePages.append(self.firstPage)
        } else {
            self.displayablePages.append(self.secondPage)
        }

        self.firstPage.onNextButton = { [weak self] in
            guard let strongSelf = self else { return }

            if strongSelf.firstPage.validationPage() {
                strongSelf.formInfoGen = strongSelf.firstPage.getFormDataInfoGen()
                strongSelf.displayablePages.append(strongSelf.secondPage)
                strongSelf.setViewControllers([strongSelf.secondPage], direction: .forward, animated: true, completion: nil)
            } else {
                var s = ToastStyle()
                s.backgroundColor = .red
                s.messageColor = .white
                strongSelf.firstPage.rootView.makeToast(Tools.getTranslate(key: "toast_form_error"), duration: 3, style: s)
            }
        }

        self.secondPage.onPreviousButton = { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.setViewControllers([strongSelf.firstPage], direction: .reverse, animated: true, completion: nil)
        }

        self.secondPage.onNextButton = {
            [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.secondPage.validationPage() {
                // on sette les données de la page
                let fields = strongSelf.secondPage.getFormDat()
                
                for element in fields {
                    strongSelf.formAnswers.append(element)
                }
                
                strongSelf.displayablePages.append(strongSelf.thirdPage)
                strongSelf.setViewControllers([strongSelf.thirdPage], direction: .forward, animated: true, completion: nil)
            } else {
                var s = ToastStyle()
                s.backgroundColor = .red
                s.messageColor = .white
                strongSelf.secondPage.rootView.makeToast(Tools.getTranslate(key: "toast_form_error"), duration: 3, style: s)
            }
        }

        self.thirdPage.onPreviousButton = { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.setViewControllers([strongSelf.secondPage], direction: .reverse, animated: true, completion: nil)
        }

        self.thirdPage.onNextButton = { [weak self] in
            guard let strongSelf = self else { return }

            if strongSelf.thirdPage.validationPage() {
                let fields = strongSelf.thirdPage.getFormDat()
                
                for element in fields {
                     strongSelf.formAnswers.append(element)
                }
                
                strongSelf.displayablePages.append(strongSelf.fourthPage)
                strongSelf.setViewControllers([strongSelf.fourthPage], direction: .forward, animated: true, completion: nil)
            } else {
                var s = ToastStyle()
                s.backgroundColor = .red
                s.messageColor = .white
                strongSelf.thirdPage.rootView.makeToast(Tools.getTranslate(key: "toast_form_error"), duration: 3, style: s)
            }
        }

        self.fourthPage.prevPage = { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.setViewControllers([strongSelf.thirdPage], direction: .reverse, animated: true, completion: nil)
        }

        self.fourthPage.onValidate = {
            [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.fourthPage.validationPage() {
                UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_FORMULAIRE_REMPLI, value: true)
                // Envoi des informations de compte au serveur
                strongSelf.sendDataCompte()
                
                // Envoi des informations du formulaire au serveur
                strongSelf.sendDataFormulaire()
                strongSelf.dismiss(animated: true, completion: nil)
            } else {
                var s = ToastStyle()
                s.backgroundColor = .red
                s.messageColor = .white
                strongSelf.fourthPage.rootView.makeToast(Tools.getTranslate(key: "toast_form_error"), duration: 3, style: s)
            }
        }

        self.dataSource = self
        self.delegate = self

        // Afficher le premier VC
        if let firstViewController = displayablePages.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // Blocage des swipes
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // Blocage des swipes
        return nil
    }
    
    /// Envoi des informations de compte au serveur
    fileprivate func sendDataCompte() {
        // on récupère les données que l'on a stockées en local pour compléter le message à envoyer
        if let gps_consent_data = UserPrefs.getInstance().object(forKey: UserPrefs.KEY_GPS_CONSENT_DATA) as? [String: Any] {
            if let form_consent_data = UserPrefs.getInstance().object(forKey: UserPrefs.KEY_FORMULAIRE_CONSENT_DATA) as? [String: Any] {
                // On complete notre objet avec les informations récupérées
                
                // informations consentement GPS
                for (key, value) in gps_consent_data {
                    self.formInfoGen[key] = value
                }
                
                // informations consentement formulaire
                for (key, value) in form_consent_data {
                    self.formInfoGen[key] = value
                }
            } else {
                 print("Aucune données de consentement du formulaire récupérée")
            }
        } else {
            print("Aucune données de consentement GPS récupérée")
        }
        
        let messageCompte = ElasticSearchAPI.getInstance().generateMessage(content: [self.formInfoGen], needBulk: false, addInfoDevice: true)
        ElasticSearchAPI.getInstance().postCompte(message: messageCompte)
    }
    
    /// Envoi les informations du formulaire (réponses aux questions) au serveur
    fileprivate func sendDataFormulaire() {
        let messageFormulaire = ElasticSearchAPI.getInstance().generateMessageFormulaire(content: self.formAnswers)
        ElasticSearchAPI.getInstance().postFormulaire(message: messageFormulaire)
    }
}
