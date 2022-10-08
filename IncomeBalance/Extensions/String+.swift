//
//  String+.swift
//  IncomeBalance
//
//  Created by Jeffrey Tabios on 10/8/22.
//

import Foundation

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        return dateFormatter.date(from: self) ?? Date.now
    }
}
