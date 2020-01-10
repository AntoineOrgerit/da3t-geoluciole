//
//  AppDelegate.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //Afficher chemin vers le dossier Documents de l'app
        print("DocumentDirectory => \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "")")

        // Copie de la Db du Bundle de l'app vers le dossier Documents de l'app
        Tools.copyFile(fileName: Constantes.DB_NAME)
        
        // params
        _ = Params.getInstance();
        
        // Permet d'upgrade la base de de données
        DatabaseManager.upgradeDatabase()

        // Demande l'autorisation de récupérer la localisation
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            // Début écoute position
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()

        }

        return true
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocation(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
        LocationTable.getInstance().insertQuery([
            LocationTable.ALTITUDE: location.altitude,
            LocationTable.LATITUDE: location.coordinate.latitude,
            LocationTable.LONGITUDE: location.coordinate.longitude,
            LocationTable.TIMESTAMP: Date().timeIntervalSince1970
        ])
    }
}
