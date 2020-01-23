//
//  NotificationHandler.swift
//  Geoluciole
//
//  Created by Alexandre BARET on 16/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

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

        let request = UNNotificationRequest(identifier: "testNotification", content: notificationContent, trigger: trigger)

        // on post la notification pour la prendre en compte
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Erreur lors de la soumission de la notification : \(error)")
            }
        }
    }

    func sendBadgeUnlocked(titleMessage: String, bodyMessage: String) {
        // Création de la notification
        let notificationContent = UNMutableNotificationContent()

        // définition du contenu
        notificationContent.title = titleMessage + " \u{1F973}"
        notificationContent.body = bodyMessage
        notificationContent.sound = .default

        // Ajout d'un icone
        if let url = Bundle.main.url(forResource: "AppIcon", withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "AppIcon", url: url, options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: "badgeNotification", content: notificationContent, trigger: trigger)

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
