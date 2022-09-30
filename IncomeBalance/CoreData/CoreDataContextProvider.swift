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
        return persistentContainer.viewContext
    }

    // The persistent container
    private var persistentContainer: NSPersistentContainer

    init(completionClosure: ((Error?) -> Void)? = nil) {
        // Create a persistent container
        persistentContainer = NSPersistentContainer(name: "IncomeBalance")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")

            }
            completionClosure?(error)
        }
    }
    // Create a context for background work
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}
