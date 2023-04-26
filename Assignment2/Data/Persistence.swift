//
//  Persistence.swift
//  Assignment2
//
//  Created by 최원우 on 25/4/2023.
//

import CoreData
struct PersistenceHandler {
    static let shared = PersistenceHandler()
    let container: NSPersistentContainer
    init() {
        container = NSPersistentContainer(name: "Coredata")
        container.loadPersistentStores { _, error in
            if let e = error {
                fatalError("Error in load data \(e).")
            }
        }
    }
}

