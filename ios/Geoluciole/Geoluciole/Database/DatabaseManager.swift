//    Copyright (c) 2020, La Rochelle Université
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
            if !DatabaseManager.getInstance().isOpen {
                 DatabaseManager.getInstance().open()
            }
            
            do {
                try DatabaseManager.getInstance().executeUpdate(table.prepareSQLForCreateTable(), values: nil)
            } catch {
                if Constantes.DEBUG {
                    print(error.localizedDescription)
                }
            }
            DatabaseManager.getInstance().close()
        }
    }

    static func upgradeDatabase() {
        
        if DatabaseManager.dbVersion < Constantes.DB_VERSION {
            // Pour upgrade, il faut faire un if de cette façon et placer l'upgrade dans le block du if
            if Constantes.DB_VERSION == 1 {
                // Créations des tables pour la Db
                DatabaseManager.createTable(tables: [LocationTable.getInstance(), BadgesTable.getInstance()])
                BadgesTable.getInstance().insertBadges()
            }
            
            // Mise a niveau de la version de la base de données
            DatabaseManager.dbVersion = Constantes.DB_VERSION
        }
    }
}
