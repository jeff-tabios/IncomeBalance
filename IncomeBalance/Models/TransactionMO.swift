//
//  TransactionMO+CoreDataClass.swift
//  IncomeBalance
//
//  Created by Jeffrey Tabios on 9/28/22.
//
//

import Foundation
import CoreData

@objc(TransactionMO)
public class TransactionMO: NSManagedObject {

}

extension TransactionMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionMO> {
        return NSFetchRequest<TransactionMO>(entityName: "TransactionMO")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var type: Int32

}

extension TransactionMO : Identifiable {

}

protocol DomainModel {
    associatedtype DomainModelType
    func toDomainModel() -> DomainModelType
}

extension TransactionMO: DomainModel {
    func toDomainModel() -> Transaction {
        return Transaction(title: title ?? "",
                           type: Int(type),
                           amount: amount,
                           amountString: String(amount),
                           date: date ?? Date.now,
                           dateString: date?.toString() ?? "")
    }
}

