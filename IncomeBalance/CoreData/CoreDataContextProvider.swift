//
//  CoreDataContextProvider.swift
//  IncomeBalance
//
//  Created by Jeffrey Tabios on 9/28/22.
//

import Foundation
import CoreData

class CoreDataContextProvider {
    // Returns the current container view context
    var viewContext: NSManagedObjectContext {
        return CoreDataContextProvider.persistentContainer.viewContext
    }

    // The persistent container
    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IncomeBalance")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")

            }
        }
        return container
    }()
    
    // Create a context for background work
    func newBackgroundContext() -> NSManagedObjectContext {
        return CoreDataContextProvider.persistentContainer.newBackgroundContext()
    }
}
