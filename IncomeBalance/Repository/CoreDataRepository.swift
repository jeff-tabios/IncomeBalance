//
//  CoreDataRepository.swift
//  IncomeBalance
//
//  Created by Jeffrey Tabios on 9/28/22.
//

import Foundation
import CoreData

protocol Repository {
    associatedtype Entity

    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error>

    // Creates an entity
    func create() -> Result<Entity, Error>

    // Deletes an entity
    func delete(entity: Entity) -> Result<Bool, Error>
}

// Enum for CoreData related errors
enum CoreDataError: Error {
    case invalidManagedObjectType
}

// Generic class for handling NSManagedObject subclasses.
class CoreDataRepository<T: NSManagedObject>: Repository {
    typealias Entity = T

    private let managedObjectContext: NSManagedObjectContext

    // Designated initializer
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    // Gets an array of NSManagedObject entities
    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error> {
        // Create a fetch request for the associated NSManagedObjectContext type.
        let fetchRequest = Entity.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            // Perform the fetch request
            if let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [Entity] {
                return .success(fetchResults)
            } else {
                return .failure(CoreDataError.invalidManagedObjectType)
            }
        } catch {
            return .failure(error)
        }
    }

    // Creates a NSManagedObject entity
    func create() -> Result<Entity, Error> {
        let className = String(describing: Entity.self)
        guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: className, into: managedObjectContext) as? Entity else {
            return .failure(CoreDataError.invalidManagedObjectType)
        }
        return .success(managedObject)
    }

    // Deletes a NSManagedObject entity
    func delete(entity: Entity) -> Result<Bool, Error> {
        managedObjectContext.delete(entity)
        return .success(true)
    }
}
