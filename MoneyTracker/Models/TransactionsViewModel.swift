//
//  TransactionsViewModel.swift
//  MoneyTracker
//
//  Created by Ilvina on 07.07.2026.
//

import Foundation
import SwiftUI
import Combine

class TransactionsViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var selectedCurrency: Currency = SettingsManager.shared.currentCurrency
    @Published private var categories: [String] = SettingsManager.shared.categories
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    var totalIncome: Double {
        transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }
    
    var totalExpense: Double {
        transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    var balance: Double {
        totalIncome - totalExpense
    }
    
    var incomeRatio: Double {
        let total = totalIncome + totalExpense
        guard total > 0 else { return 0.5 }
        return totalIncome / total
    }
    
    var lastFiveTransactions: [Transaction] {
        Array(transactions.sorted { $0.date > $1.date }.prefix(5))
    }
    
    var availableCategories: [String] {
        categories
    }
    
    var currentCurrency: Currency {
        selectedCurrency
    }
    
    var allTransactions: [Transaction] {
        transactions.sorted { $0.date > $1.date }
    }
    
    func addTransaction(
        amount: String,
        type: TransactionType,
        category: String,
        comment: String,
        date: Date
    ) -> Bool {
        guard let amountValue = Double(amount), amountValue > 0 else {
            errorMessage = "Введите корректную сумму"
            showError = true
            return false
        }
        
        let transaction = Transaction(
            amount: amountValue,
            type: type,
            category: category,
            comment: comment.isEmpty ? nil : comment,
            date: date
        )
        
        transactions.append(transaction)
        return true
    }
    
    func updateCurrency() {
        selectedCurrency = SettingsManager.shared.currentCurrency
    }
    
    func updateCategories() {
        categories = SettingsManager.shared.categories
    }
}
