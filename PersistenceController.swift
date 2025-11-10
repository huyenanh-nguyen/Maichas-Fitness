//
//  PersistenController.swift
//  Yuen Fitness
//
//  Created by Huyen Anh Nguyen on 10.11.25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // Container für Core Data
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FitnessApp") // Name muss deinem .xcdatamodeld entsprechen
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
