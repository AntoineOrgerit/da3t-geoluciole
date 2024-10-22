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
import UserNotifications

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {

    fileprivate static var INSTANCE: NotificationHandler!
    fileprivate var userNotificationCenter: UNUserNotificationCenter

    fileprivate override init() {
        self.userNotificationCenter = UNUserNotificationCenter.current()
        super.init()
        self.userNotificationCenter.delegate = self
    }

    static func getInstance() -> NotificationHandler {
        if INSTANCE == nil {
            INSTANCE = NotificationHandler()
        }

        return INSTANCE
    }

    /// Demande l'autorisation d'envoyer des notifications à l'utilisateur
    func requestNotificationAuthorization() {
        // On définit les élements que l'on veut utiliser pour les notifications
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .sound)

        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Erreur lors de l'autorisation des notifications : \(error)")
            }
        }
    }

    /// Envoi d'une notification lorsque l'on coupe l'application pour informer l'utilisateur que le tracking va être coupé
    func sendNotificationStopTracking() {
        // Création de la notification
        let notificationContent = UNMutableNotificationContent()

        // définition du contenu
        notificationContent.title = "\u{26a0} Attention \u{26a0}"
        notificationContent.body = "La coupure de l'application ne permet pas de suivre vos déplacements. Veuillez relancer l'application pour reprendre le suivi"

        // Ajout d'un icone
        if let url = Bundle.main.url(forResource: "AppIcon", withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "AppIcon", url: url, options: nil) {
                notificationContent.attachments = [attachment]
            }
        }

        // gestion de l'émission
        // temps exprimé en secondes
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: "exitNotification", content: notificationContent, trigger: trigger)

        // on post la notification pour la prendre en compte
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Erreur lors de la soumission de la notification : \(error)")
            }
        }
    }

    func sendBadgeUnlocked(titleMessage: String, bodyMessage: String, idNotification: String) {
        // Création de la notification
        let notificationContent = UNMutableNotificationContent()

        // définition du contenu
        notificationContent.title = titleMessage
        notificationContent.body = bodyMessage
        notificationContent.sound = .default

        // Ajout d'un icone
        if let url = Bundle.main.url(forResource: "AppIcon", withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "AppIcon", url: url, options: nil) {
                notificationContent.attachments = [attachment]
            }
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: idNotification, content: notificationContent, trigger: trigger)

        // on post la notification pour la prendre en compte
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Erreur lors de la soumission de la notification : \(error)")
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
