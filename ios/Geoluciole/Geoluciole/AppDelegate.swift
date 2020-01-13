//
//  AppDelegate.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {

    let locationManager = CLLocationManager()
    let userNotificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //Afficher chemin vers le dossier Documents de l'app
        print("DocumentDirectory => \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "")")

        // Copie de la Db du Bundle de l'app vers le dossier Documents de l'app
        Tools.copyFile(fileName: Constantes.DB_NAME)

        // params
        _ = Params.getInstance()

        // Permet d'upgrade la base de de données
        DatabaseManager.upgradeDatabase()

        // Demande l'autorisation de récupérer la localisation
        locationManager.requestAlwaysAuthorization()

        // Ecoute de la position uniquement is l'autorisation est donnée
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.distanceFilter = 10 // on doit bouger de 10m pour détecter un changement
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

        userNotificationCenter.delegate = self
        requestNotificationAuthorization()

        sendPostElasticSearch()

        return true
    }

    /// Appelé lorsque l'application va se terminer (coupure via le gestionnaire d'app par exemple)
    func applicationWillTerminate(_ application: UIApplication) {
        NSLog("App killed")
        if CLLocationManager.locationServicesEnabled() {
            sendNotificationStopTracking()
            locationManager.stopUpdatingLocation()
        }
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // Location PART

    /// Appelé lorsque l'on reçoit une nouvelle position GPS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // on effectue l'insertion uniquement si la valeur n'est pas nil
        guard let location = locations.last else {
            return
        }

        NSLog("Location update")

        LocationTable.getInstance().insertQuery([
            LocationTable.ALTITUDE: location.altitude,
            LocationTable.LATITUDE: location.coordinate.latitude,
            LocationTable.LONGITUDE: location.coordinate.longitude,
            LocationTable.TIMESTAMP: Date().timeIntervalSince1970
        ])
    }

    /// Appelé lorsqu'une erreur liée à la localisation est capturée
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let err = error as? CLError {
            switch err {
            case CLError.locationUnknown:
                NSLog("Position inconnue")
            case CLError.denied:
                locationManager.stopUpdatingLocation()
            default:
                NSLog("Erreur inconnue : \(err.localizedDescription)")
            }
        }
    }


    // Notification PART

    /// Demande l'autorisation d'envoyer des notifications à l'utilisateur
    func requestNotificationAuthorization() {
        // On définit les élements que l'on veut utiliser pour les notifications
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .sound)

        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                NSLog("Erreur lors de l'autorisation des notifications : \(error)")
            }
        }
    }

    /// Envoi d'une notification lorsque l'on coupe l'application pour information
    /// l'utilisateur que le tracking va être coupé
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
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: "testNotification", content: notificationContent, trigger: trigger)

        // on post la notification pour la prendre en compte
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                NSLog("Erreur lors de la soumission de la notification : \(error)")
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

    // Envoi serveur PART

    func sendPostElasticSearch() {
        // création du message à envoyer

        // récupération des localisations en BDD SQLite
        let result = LocationTable.getInstance().selectQuery()
         
        if result.count > 0 {
            var locations: [Location] = [Location]()

            // Pour chaque instance récupérée, on crée un objet Location associé que l'on ajoute dans un tableau
            for location in result {
                let loc = Location()

                for (key, value) in location {
                    switch key {
                    case LocationTable.ALTITUDE:
                        loc.altitude = value as? Double

                    case LocationTable.LATITUDE:
                        loc.latitude = value as? Double

                    case LocationTable.LONGITUDE:
                        loc.longitude = value as? Double

                    case LocationTable.TIMESTAMP:
                        loc.timestamp = value as? Double

                    default:
                        NSLog("Aucune propriété \(key) dans l'objet Location")
                    }
                }
                locations.append(loc)
            }

            // Si le tableau n'est pas vide, on envoi notre message
            if locations.count > 0 {
                // pour ne pas identifier directement le terminal, on génère un identifier à partir de l'uuid
                let uuid = UIDevice.current.identifierForVendor?.uuidString

                // on récupère le hashCode de notre uuid pour masquer l'identité du terminal
                let identifier = String(-1 * uuid!.hashCode())

                // équivalent identifier.substring(2, 8)
                let range = identifier.index(identifier.startIndex, offsetBy: 2)..<identifier.index(identifier.startIndex, offsetBy: 9)
                let substringIdentifier = identifier[range]

                let message = ElasticSearchAPIMessage(identifier: String(substringIdentifier), locations: locations)
                ElasticSearchAPI.getInstance().postLocations(message)
            }
        }
    }

}
