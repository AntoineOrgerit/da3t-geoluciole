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
        
        // Demande d'autorisation pour envoyer des notifications
        NotificationHandler.getInstance().requestNotificationAuthorization()

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

