//
//  TransactionRepository.swift
//  IncomeBalance
//
//  Created by Jeffrey Tabios on 9/28/22.
//

import Foundation
import CoreData

// Protocol that describes a Transaction repository.
protocol TransactionRepositoryInterface {
    // Get a gook using a predicate
    func getTransactions(predicate: NSPredicate?) -> Result<[Transaction], Error>
    // Creates a Transaction on the persistance layer.
    func create(Transaction: Transaction) -> Result<Bool, Error>
}

// Transaction Repository class.
class TransactionRepository {
    // The Core Data Transaction repository.
    private let repository: CoreDataRepository<TransactionMO>
    private var entities: [NSManagedObject] = []
    
    // Designated initializer
    init(context: NSManagedObjectContext) {
        self.repository = CoreDataRepository<TransactionMO>(managedObjectContext: context)
    }
}

extension TransactionRepository: TransactionRepositoryInterface {
    // Get a gook using a predicate
    @discardableResult func getTransactions(predicate: NSPredicate?) -> Result<[Transaction], Error> {
        let sort = NSSortDescriptor(key: #keyPath(TransactionMO.date), ascending: false)
        let result = repository.get(predicate: predicate, sortDescriptors: [sort])
        switch result {
        case .success(let TransactionsMO):
            entities = TransactionsMO
            
            // Transform the NSManagedObject objects to domain objects
            let Transactions = TransactionsMO.map { TransactionMO -> Transaction in
                return TransactionMO.toDomainModel()
            }
            
            return .success(Transactions)
        case .failure(let error):
            // Return the Core Data error.
            return .failure(error)
        }
    }

    // Creates a Transaction on the persistance layer.
    @discardableResult func create(Transaction: Transaction) -> Result<Bool, Error> {
        let result = repository.create()
        switch result {
        case .success(let TransactionMO):
            // Update the Transaction properties.
            TransactionMO.title = Transaction.title
            TransactionMO.type = Int32(Transaction.type)
            TransactionMO.amount = Transaction.amount
            TransactionMO.date = Transaction.date
            return .success(true)

        case .failure(let error):
            // Return the Core Data error.
            return .failure(error)
        }
    }
    
    // Delete a item using a predicate
    func deleteTransaction(at index: Int) {
        repository.delete(entity: entities[index] as! TransactionMO)
    }
    
    // Delete a item using a predicate
    @discardableResult func deleteTransactions(predicate: NSPredicate?) -> Result<Bool, Error> {
        let result = repository.get(predicate: predicate, sortDescriptors: nil)
        switch result {
        case .success(let TransactionsMO):
            if !TransactionsMO.isEmpty {
                TransactionsMO.forEach { transaction in
                    repository.delete(entity: transaction)
                }
                return .success(true)
            } else {
                return .success(false)
            }
            
        case .failure(let error):
            // Return the Core Data error.
            return .failure(error)
        }
    }
}
