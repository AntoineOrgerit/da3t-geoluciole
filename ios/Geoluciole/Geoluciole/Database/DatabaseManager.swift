//
//  DatabaseManager.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class DatabaseManager {

    fileprivate static var DATABASE_INSTANCE: FMDatabase!
    
    static let sharedQueue: FMDatabaseQueue = {
        return FMDatabaseQueue(path: Tools.getPath(Constantes.DB_NAME))!
    }()
    
    static var dbVersion: Int {
        get {
            let db = DatabaseManager.getInstance()
            db.open()
            let dbVersion = Int(DatabaseManager.getInstance().userVersion)
            db.close()
            return dbVersion
        }
        set {
            let db = DatabaseManager.getInstance()
            db.open()
            db.userVersion = UInt32(Constantes.DB_VERSION)
            db.close()
        }
    }

    static func getInstance() -> FMDatabase {
        if DATABASE_INSTANCE == nil {
            DATABASE_INSTANCE = FMDatabase(path: Tools.getPath(Constantes.DB_NAME))
        }

        return DATABASE_INSTANCE
    }

    /// Permet de créer toutes les tables de la Db
    /// - Parameter tables: la liste des tables à créer
    static func createTable(tables: [Table]) {

        for table in tables {
            DatabaseManager.getInstance().open()
            do {
                try DatabaseManager.getInstance().executeUpdate(table.prepareSQLForCreateTable(), values: nil)
            } catch {
                print(error.localizedDescription)
            }
            DatabaseManager.getInstance().close()
        }
    }

    static func upgradeDatabase() {
        
        if DatabaseManager.dbVersion < Constantes.DB_VERSION {
            // Pour upgrade, il faut faire un if de cette façon et placer l'upgrade dans le block du if
            if Constantes.DB_VERSION == 1 {
                // Créations des tables pour la Db
                DatabaseManager.createTable(tables: [LocationTable.getInstance()])
            }
            
            // Mise a niveau de la version de la base de données
            DatabaseManager.dbVersion = Constantes.DB_VERSION
        }
    }
}
