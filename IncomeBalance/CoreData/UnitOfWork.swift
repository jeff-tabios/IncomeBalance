//
//  UnitOfWork.swift
//  IncomeBalance
//
//  Created by Jeffrey Tabios on 9/28/22.
//

import Foundation
import CoreData

class UnitOfWork {
    private let context: NSManagedObjectContext

    let transactionRepository: TransactionRepository

    init(context: NSManagedObjectContext) {
        self.context = context
        self.transactionRepository = TransactionRepository(context: context)
    }

    @discardableResult func saveChanges() -> Result<Bool, Error> {
        do {
            try context.save()
            return .success(true)
        } catch {
            context.rollback()
            return .failure(error)
        }
    }
}
