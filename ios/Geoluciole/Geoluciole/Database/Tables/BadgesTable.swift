//
//  BadgesTable.swift
//  Geoluciole
//
//  Created by local192 on 21/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class BadgesTable: Table {

    fileprivate static var INSTANCE: BadgesTable!

    static let ID = "id"
    static let TYPE = "type"
    static let NAME = "name"
    static let DESCRIPTION = "description"
    static let LATITUDE = "latitude"
    static let LONGITUDE = "longitude"
    static let PROXIMITY = "proximity"
    static let DISTANCE = "distance"
    static let RESOURCE = "resource"
    static let IS_OBTAIN = "is_obtain"

    fileprivate override init() {
        super.init()

        self.tableName = "badges"
        self.columns = [
            TableColumn(columnName: BadgesTable.ID, columnType: "INTEGER PRIMARY KEY", canBeNull: false),
            TableColumn(columnName: BadgesTable.TYPE, columnType: "VARCHAR", canBeNull: false),
            TableColumn(columnName: BadgesTable.NAME, columnType: "VARCHAR", canBeNull: false),
            TableColumn(columnName: BadgesTable.DESCRIPTION, columnType: "VARCHAR", canBeNull: false),
            TableColumn(columnName: BadgesTable.LATITUDE, columnType: "DOUBLE", canBeNull: true),
            TableColumn(columnName: BadgesTable.LONGITUDE, columnType: "DOUBLE", canBeNull: true),
            TableColumn(columnName: BadgesTable.PROXIMITY, columnType: "INTEGER", canBeNull: true),
            TableColumn(columnName: BadgesTable.DISTANCE, columnType: "INTEGER", canBeNull: true),
            TableColumn(columnName: BadgesTable.RESOURCE, columnType: "VARCHAR", canBeNull: false),
            TableColumn(columnName: BadgesTable.IS_OBTAIN, columnType: "BOOLEAN", canBeNull: false)
        ]
    }

    static func getInstance() -> BadgesTable {
        if INSTANCE == nil {
            INSTANCE = BadgesTable()
        }

        return INSTANCE
    }

    func insertBadges() {

        var badgesJSON = [Any]()
        var badgesQueryResult = [[String: Any]]()

        if Constantes.DEBUG {
            print("Début insertion des badges")
        }

        guard let path = Bundle.main.url(forResource: "badges", withExtension: "json") else { return }

        // Lecture du JSON
        do {

            let data = try Data(contentsOf: path, options: .mappedIfSafe)
            let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: Any]
            badgesJSON = jsonResponse["badgesList"] as! [Any]
        } catch let error {
            if Constantes.DEBUG {
                print("\(#function) ERROR : " + error.localizedDescription)
            }
        }

        // Permet de savoir si on a déjà insérer les badges
        BadgesTable.getInstance().selectQuery(completion: { (success, queryResult, error) in
            if error == nil {
                badgesQueryResult = queryResult
            } else {
                if Constantes.DEBUG {
                    print("\(#function) ERROR : " + error!.localizedDescription)
                }
            }
        })

        if badgesQueryResult.count == badgesJSON.count {
            // On a déjà inséré les badges
            if Constantes.DEBUG {
                print("Badges already inserted !")
            }
        } else {
            // On peut insérer les badges
            for object in badgesJSON {
                var badge = object as! [String: Any]
                badge["is_obtain"] = false
                BadgesTable.getInstance().insertQuery(badge)
            }

            if Constantes.DEBUG {
                print("Badges inserted !")
            }
        }

        if Constantes.DEBUG {
            print("Fin insertion des badges")
        }
    }
}
