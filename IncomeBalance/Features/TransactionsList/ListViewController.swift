//
//  ListViewController.swift
//  IncomeBalance
//
//  Created by Jeffrey Tabios on 9/27/22.
//

import UIKit
import Combine
class ListViewController: UIViewController {
    
    let viewModel = TransactionsViewModel()

    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var topPanel: UIView!
    @IBOutlet weak var expense: UILabel!
    @IBOutlet weak var income: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupStyle()
    }
}

extension ListViewController {
    func setup() {
        viewModel.refreshData.sink { [weak self] _ in
            if let self = self {
                self.tableView.reloadData()
                self.expense.text = self.viewModel.expense
                self.income.text = self.viewModel.income
                self.balance.text = self.viewModel.balance
                self.progress.progress = self.viewModel.progress
            }
        }.store(in: &cancellables)
        
        viewModel.refreshTransactions()
    }
    
    func setupStyle() {
        tableView.layer.cornerRadius = 10
        topPanel.layer.cornerRadius = 10
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = CGFloat(0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AddTransactionViewController
        destination.delegate = self
    }
    
    func showDeleteDialog(indexPath: IndexPath) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.viewModel.deleteTransaction(at: indexPath.row)
            self.viewModel.refreshTransactions()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

extension ListViewController: AddDelegate {
    func didAddTransaction(title: String, amount: Double, type: Int) {
        let transaction = Transaction(title: title,
                                      type: type,
                                      amount: amount,
                                      amountString: "",
                                      date: Date.now,
                                      dateString: "")
        _ = viewModel.addTransaction(t: transaction)
        
        viewModel.refreshTransactions()
    }
}

// MARK: Table
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.transactions[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor = UIColor.lightGray
         
        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.text = viewModel.transactions[section]?[0].dateString
        view.addSubview(lbl)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tcell", for: indexPath) as! TransactionCell
        if let transaction = viewModel.transactions[indexPath.section]?[indexPath.row] {
            cell.title.text = transaction.title
            cell.amount.text = transaction.amountString
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDeleteDialog(indexPath: indexPath)
    }
    
}
