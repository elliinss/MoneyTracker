//
//  BalanceCard.swift
//  MoneyTracker
//
//  Created by Ilvina on 07.07.2026.
//

import Foundation
import SwiftUI

struct BalanceCard: View {
    let balance: Double
    let income: Double
    let expense: Double
    let currency: Currency
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Текущий баланс")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("\(balance, specifier: "%.2f") \(currency.rawValue)")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(balance >= 0 ? .green : .red)
            
            HStack(spacing: 40) {
                VStack {
                    Text("Доходы")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("+ \(income, specifier: "%.2f") \(currency.rawValue)")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                
                Divider()
                    .frame(height: 30)
                
                VStack {
                    Text("Расходы")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("- \(expense, specifier: "%.2f") \(currency.rawValue)")
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    BalanceCard(
        balance: 1500,
        income: 2000,
        expense: 500,
        currency: .rub
    )
}

