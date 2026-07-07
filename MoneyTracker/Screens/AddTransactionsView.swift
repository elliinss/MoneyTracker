//
//  AddTransactionsView.swift
//  MoneyTracker
//
//  Created by Ilvina on 06.07.2026.
//

import Foundation
import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var transactions: [Transaction]
    @Binding var selectedCurrency: Currency
    
    @State private var amount = ""
    @State private var selectedType: TransactionType = .expense
    @State private var selectedCategory = "Еда"
    @State private var comment = ""
    @State private var date = Date()
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var categories: [String] {
        SettingsManager.shared.categories
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Сумма") {
                    TextField("0.00", text: $amount)
                        .keyboardType(.decimalPad)
                        .font(.title)
                    
                    Picker("Тип", selection: $selectedType) {
                        Text("Расход").tag(TransactionType.expense)
                        Text("Доход").tag(TransactionType.income)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Категория") {
                    Picker("Выберите категорию", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Дополнительно") {
                    TextField("Комментарий (необязательно)", text: $comment)
                    
                    DatePicker("Дата", selection: $date, displayedComponents: .date)
                }
                
                Section {
                    Button {
                        saveTransaction()
                    } label: {
                        Text("Сохранить")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.blue)
                    .disabled(amount.isEmpty || Double(amount) == nil)
                }
            }
            .navigationTitle("Новая операция")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
            }
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK") { }
            }
        }
    }
    
    private func saveTransaction() {
        guard let amountValue = Double(amount), amountValue > 0 else {
            alertMessage = "Введите корректную сумму"
            showAlert = true
            return
        }
        
        let transaction = Transaction(
            amount: amountValue,
            type: selectedType,
            category: selectedCategory,
            comment: comment.isEmpty ? nil : comment,
            date: date
        )
        
        transactions.append(transaction)
        dismiss()
    }
}

