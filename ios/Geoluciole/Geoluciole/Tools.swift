//
//  Tools.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

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
}

// Source fonction de hashCode : https://stackoverflow.com/a/44413863
extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
}

extension String {
    var asciiArray: [UInt32] {
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }

    func hashCode() -> Int32 {
        var h: Int32 = 0
        for i in self.asciiArray {
            h = 31 &* h &+ Int32(i)
        }

        return h
    }
}

