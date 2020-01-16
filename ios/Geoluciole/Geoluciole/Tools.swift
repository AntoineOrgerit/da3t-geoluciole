//
//  Tools.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Tools {

    /// Permet de trouver le chemin pour le fichier passé en paramètre
    static func getPath(_ fileName: String) -> String {

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)

        return fileURL.path
    }

    /// Permet de copier un fichier du Bundle de l'application vers le dossier Documents de l'application
    static func copyFile(fileName: String) {
        let dbPath: String = getPath(fileName as String)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {

            let documentsURL = Bundle.main.resourceURL!
            let fromPath = documentsURL.appendingPathComponent(fileName)

            var error: NSError?
            do {
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
            } catch let e as NSError {
                error = e
            }

            if let error = error {
                if Constantes.DEBUG {
                    print("Error Occured : \(error.localizedDescription)")
                }
            } else {
                if Constantes.DEBUG {
                    print("Successfully Copy : Your file copy successfully")
                }
            }
        }
    }

    static func joinWithCharacter(_ separator: String, _ values: [String]) -> String {
        return Tools.joinWithCharacter(nil, separator, values)
    }

    static func joinWithCharacter(_ beforeWord: String?, _ separator: String, _ values: [String]) -> String {
        var s = ""
        let endIndex = values.count - 1

        for i in 0...endIndex {

            if let before = beforeWord {
                s += before
            }

            s += values[i]


            if i != endIndex {
                s += ", "
            }
        }

        return s
    }

    static func getStatusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }

    static func getAppName() -> String {
        return Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    }

    static func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }

    static func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }

    /// Retourne l'identifiant de l'utilisateur
    static func getIdentifier() -> String {
        var identifier: String = ""

        // On vérifie si on a un identifiant de généré
        let id = UserPrefs.getInstance().string(forKey: UserPrefs.KEY_IDENTIFIER)

        // Si oui, on le récupère
        if id != "" {
            identifier = id

            // Sinon, on en génère un
        } else {
            if Constantes.DEBUG {
                print("Aucun identifiant existant ! Génération en cours ...")
            }


            // pour ne pas identifier directement le terminal, on génère un identifier à partir de l'uuid
            let uuid = UIDevice.current.identifierForVendor?.uuidString

            // on récupère le hashCode de notre uuid pour masquer l'identité du terminal
            let hashId = String(-1 * uuid!.hashCode())

            // équivalent identifier.substring(2, 8)
            let range = hashId.index(hashId.startIndex, offsetBy: 2)..<hashId.index(hashId.startIndex, offsetBy: 9)
            identifier = String(hashId[range])

            // et on sauvegarde le paramètre
            UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_IDENTIFIER, value: identifier)
        }

        return identifier
    }

    static func convertDate(date: String) -> Date {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm"
        return df.date(from: date)!
    }

    static func convertDate(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm"
        return df.string(from: date)
    }

    static func getDistance(coordonnee1: CLLocation, coordonnee2: CLLocation) -> CLLocationDistance {
        return coordonnee1.distance(from: coordonnee2)
    }

    static func getDistStat() -> Double {
        guard let dist_parcourue = UserPrefs.getInstance().object(forKey: UserPrefs.KEY_DISTANCE) as? Double else {
            return 0
        }
        
        if Constantes.DEBUG {
            print("Distance parcourue :\(dist_parcourue)")
        }

        return roundDist(dist_parcourue, places: 2)
    }

    static func roundDist(_ value: Double, places: Int) -> Double {
        let divisor = pow(10.0, Double(places))

        return round(value * divisor) / divisor
    }

    static func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
}
