//
//  AddTransactionViewController.swift
//  IncomeBalance
//
//  Created by Jeffrey Tabios on 9/30/22.
//

import Foundation
import UIKit

protocol AddDelegate: AnyObject {
    func didAddTransaction(title: String, amount: Double, type: Int)
}

final class AddTransactionViewController: UIViewController {
    @IBOutlet weak var typeSwitch: UISegmentedControl!
    @IBOutlet weak var transactionTitle: UITextField!
    @IBOutlet weak var amount: UITextField!
    
    weak var delegate: AddDelegate?
    
    override func viewDidLoad() {
        transactionTitle.addDoneButtonOnKeyboard()
        amount.addDoneButtonOnKeyboard()
    }
    
    @IBAction func onAdd(_ sender: Any) {
        if let title = transactionTitle.text,
           let amount = amount.text,
            let doubleAmount = Double(amount),
           doubleAmount > 0 &&
            !title.isEmpty {
            
            delegate?.didAddTransaction(title: title, amount: doubleAmount, type: Int(typeSwitch.selectedSegmentIndex + 1))
            
            dismiss(animated: true)
        }
    }
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true)
    }
}
