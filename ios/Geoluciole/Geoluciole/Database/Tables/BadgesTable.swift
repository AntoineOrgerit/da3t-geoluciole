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
            TableColumn(columnName: BadgesTable.DISTANCE, columnType: "DOUBLE", canBeNull: true),
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
