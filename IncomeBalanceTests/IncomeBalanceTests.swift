//
//  IncomeBalanceTests.swift
//  IncomeBalanceTests
//
//  Created by Jeffrey Tabios on 9/27/22.
//

import XCTest
@testable import IncomeBalance

class IncomeBalanceTests: XCTestCase {
    
    func testAdd3TransactionShouldInsertTransactions() {
        let sut = TransactionsViewModel()
        let transaction = Transaction(title: "RandomSalaryTest###",
                                      type: 1,
                                      amount: 12,
                                      amountString: "",
                                      date: Date.now,
                                      dateString: "")
        let addResult1 = sut.addTransaction(t: transaction)
        let addResult2 = sut.addTransaction(t: transaction)
        let addResult3 = sut.addTransaction(t: transaction)

        XCTAssertEqual(addResult1, true)
        XCTAssertEqual(addResult2, true)
        XCTAssertEqual(addResult3, true)

        let transactions: [Transaction] = sut.getTransactions(predicate: NSPredicate(format: "title == %@", "RandomSalaryTest###"))
        XCTAssertEqual(transactions.count, 3)
        print(transactions)

        //Clean
        let deleteResult = sut.deleteTransactions(predicate: NSPredicate(format: "title == %@", "RandomSalaryTest###"))
        XCTAssertEqual(deleteResult, true)
    }
    
    
    
    //Below is just for adding starting data to app similar to the instructions
    
//    func testInsertTransactions() {
//        let sut = TransactionsViewModel()
//        var newtransactions: [Transaction] = []
//
//        //Create transaction
//        newtransactions.append(Transaction(title: "Coffee From Starbucks",
//                                        type: 2,
//                                        amount: 7,
//                                           amountString: "",
//                                           date: "10-10-2021".toDate(),
//                                           dateString: ""))
//
//        newtransactions.append(Transaction(title: "Grocery from Nestor's",
//                                        type: 2,
//                                        amount: 56,
//                                           amountString: "",
//                                           date: "10-10-2021".toDate(),
//                                           dateString: ""))
//
//        newtransactions.append(Transaction(title: "Salary",
//                                        type: 1,
//                                        amount: 1000,
//                                           amountString: "",
//                                           date: "10-10-2021".toDate(),
//                                           dateString: ""))
//
//        newtransactions.append(Transaction(title: "Food take out",
//                                        type: 2,
//                                        amount: 57,
//                                           amountString: "",
//                                           date: "10-10-2021".toDate(),
//                                           dateString: ""))
//
//        newtransactions.append(Transaction(title: "Phone bill",
//                                        type: 2,
//                                        amount: 90,
//                                           amountString: "",
//                                           date: "09-10-2021".toDate(),
//                                           dateString: ""))
//
//        newtransactions.forEach { transaction in
//            _ = sut.addTransaction(t: transaction)
//        }
//
//        sut.refreshTransactions()
//
//        print()
//        sut.transactions.forEach { t in
//            print(t)
//        }
//        print()
//    }
    
}
