//
//  TransactionRow.swift
//  MoneyTracker
//
//  Created by Ilvina on 07.07.2026.
//

import Foundation
import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    let currency: Currency
    
    var body: some View {
        HStack {
            Image(systemName: transaction.type == .income ? "arrowshape.up.fill" : "arrowshape.down.fill")
                        .foregroundColor(transaction.type == .income ? .green : .red)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.category)
                if let comment = transaction.comment {
                    Text(comment)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(transaction.amount, specifier: "%.2f") \(currency.rawValue)")
                    .font(.headline)
                
                Text(transaction.date, style: .date)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 2)
    }
}
