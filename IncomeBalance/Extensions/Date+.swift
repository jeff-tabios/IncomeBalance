//
//  Date+.swift
//  IncomeBalance
//
//  Created by Jeffrey Tabios on 9/30/22.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyy"
        return dateFormatter.string(from: self)
    }
}
