//
//  TransactionsViewModel.swift
//  IncomeBalance
//
//  Created by Jeffrey Tabios on 9/28/22.
//

import Foundation
import CoreData
import Combine

class TransactionsViewModel {
    private let coreDataContextProvider = CoreDataContextProvider()
    private let moc: NSManagedObjectContext
    private let unitOfWork: UnitOfWork
    
    let refreshData = PassthroughSubject<Bool, Never>()
    var transactions = [Int: [Transaction]]()
    var expense: String = ""
    var income: String = ""
    var balance: String = ""
    var progress: Float = 0.5
    
    init() {
        moc = coreDataContextProvider.viewContext
        unitOfWork = UnitOfWork(context: moc)
    }
    
    func refreshTransactions() {
        var expense = 0.0
        var income = 0.0
        var balance = 0.0
        var lastDate = ""
        var sectionCount = -1
        
        let transactions = getTransactions(predicate: nil)
        
        //Format & gather expenses and incomes
        let formattedTransactions = transactions.map({ t -> Transaction in
            if t.type == 1 {
                income += t.amount
            } else {
                expense += t.amount
            }
            
            return format(transaction: t)
        })
        
        //Create dictionary
        self.transactions = Dictionary(grouping: formattedTransactions) { (t) -> Int in
            if t.dateString != lastDate {
                sectionCount += 1
                lastDate = t.dateString
            }
            return sectionCount
        }
        
        balance = income - expense
        
        self.income = "$\(Int(income))"
        self.expense = "$\(Int(expense))"
        self.balance = "$\(Int(balance))"
        
        self.progress = Float(expense / (income + expense)) * 100 * 0.01
        
        refreshData.send(true)
    }
    
    func format(transaction t: Transaction) -> Transaction {
        var amountSign = ""
        if t.type == 2 { amountSign = "-" }
        return Transaction(title: t.title,
                           type: t.type,
                           amount: t.amount,
                           amountString: "\(amountSign)$\(Int(t.amount))",
                           date: t.date,
                           dateString: t.dateString)
        
    }
}

extension TransactionsViewModel {
    func getTransactions(predicate: NSPredicate? = nil) -> [Transaction] {
        let result = unitOfWork.transactionRepository.getTransactions(predicate: predicate)
        switch(result) {
        case .success(let transactions):
            return transactions
        case .failure(let e):
            print(e)
        }
        
        return []
    }
    
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
    
    func deleteTransaction(at index: Int) {
        unitOfWork.transactionRepository.deleteTransaction(at: index)
        unitOfWork.saveChanges()
    }
    
    func deleteTransactions(predicate: NSPredicate? = nil) -> Bool {
        let result = unitOfWork.transactionRepository.deleteTransactions(predicate: predicate)
        
        switch(result) {
        case .success(let isDeleted):
            if isDeleted {
                unitOfWork.saveChanges()
                return true
            }
        case .failure(let e):
            print(e)
        }
        
        return false
    }
}
