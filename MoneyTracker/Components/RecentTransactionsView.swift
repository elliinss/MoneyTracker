//
//  RecentTransactionsView.swift
//  MoneyTracker
//
//  Created by Ilvina on 07.07.2026.
//

import Foundation
import SwiftUI

struct RecentTransactionsView: View {
    let transactions: [Transaction]
    let currency: Currency
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Последние операции")
                .bold()
            if transactions.isEmpty {
                VStack(spacing: 8) {
                    Text("Нет операций")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .cornerRadius(12)
            } else {
                ForEach(transactions) { transaction in
                    TransactionRow(transaction: transaction, currency: currency)
                }
            }
        }
        .padding()
        .cornerRadius(16)
    }
}
