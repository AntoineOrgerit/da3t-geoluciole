//
//  DatabaseManager.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation

class DatabaseManager {

    fileprivate static var DATABASE_INSTANCE: FMDatabase? = nil

    init() {

    }

    static func getInstance() -> FMDatabase {
        if DATABASE_INSTANCE == nil {
            DATABASE_INSTANCE = FMDatabase(path: Tools.getPath(Constantes.DB_NAME))
        }

        return DATABASE_INSTANCE!
    }
    
    /// Permet de créer toutes les tables de la Db
    /// - Parameter tables: la liste des tables à créer
    static func createAllTables(tables: [Table]) {

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
}
