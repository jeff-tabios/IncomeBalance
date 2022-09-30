//
//  AddTransactionViewModel .swift
//  IncomeBalance
//
//  Created by Jeffrey Tabios on 9/29/22.
//

import Foundation
import CoreData

class AddTransactionViewModel {
    let coreDataContextProvider = CoreDataContextProvider()
    let moc: NSManagedObjectContext
    let unitOfWork: UnitOfWork
    
    init() {
        moc = coreDataContextProvider.viewContext
        unitOfWork = UnitOfWork(context: moc)
    }
}

extension AddTransactionViewModel {
    
    func addTransaction(t: Transaction) -> Bool {
        let result = unitOfWork.transactionRepository.create(Transaction: t)
        switch(result) {
        case .success(let isAdded):
            if isAdded {
                unitOfWork.saveChanges()
                return true
            } else {
                return false
            }
        case .failure:
            return false
        }
    }
}
