//
//  AppDelegate.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let userNotificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //Afficher chemin vers le dossier Documents de l'app
        if Constantes.DEBUG {
            print("DocumentDirectory => \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "")")
        }

        // Copie de la Db du Bundle de l'app vers le dossier Documents de l'app
        Tools.copyFile(fileName: Constantes.DB_NAME)

        // Copie des CGU dans le dossier Documents de l'app
        Tools.copyFile(fileName: Constantes.CGU_NAME)

        // Copie du fichiers des badges
        Tools.copyFile(fileName: Constantes.BADGES_FILENAME)

        // Permet d'upgrade la base de de données
        DatabaseManager.upgradeDatabase()

        // On démarre la timer de localisation si la collecte des données est activée
        if LocationHandler.getInstance().locationCanBeUsed() {
            LocationHandler.getInstance().requestLocationAuthorization()
            CustomTimer.getInstance().startTimerLocalisation()

            LocationHandler.startTrackingBadges()
        }

        return true
    }

    /// Appelé lorsque l'application va se terminer (coupure via le gestionnaire d'app par exemple)
    func applicationWillTerminate(_ application: UIApplication) {
        if Constantes.DEBUG {
            print("App killed")
        }

        if LocationHandler.getInstance().locationCanBeUsed() && UserPrefs.getInstance().bool(forKey: UserPrefs.KEY_SEND_DATA) {
            NotificationHandler.getInstance().sendNotificationStopTracking()
            LocationHandler.getInstance().stopLocationTracking()
            CustomTimer.getInstance().stopTimerLocation()
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
}

