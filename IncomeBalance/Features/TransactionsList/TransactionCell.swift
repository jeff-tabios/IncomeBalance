//
//  TransactionCell.swift
//  IncomeBalance
//
//  Created by Jeffrey Tabios on 9/30/22.
//

import Foundation
import UIKit

final class TransactionCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override func prepareForReuse() {
        title.text = ""
        amount.text = ""
    }
}
