//
//  Tools.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

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
                print("Error Occured : \(error.localizedDescription)")
            } else {
                print("Successfully Copy : Your file copy successfully")
            }
        }
    }

}
