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
    
    @ObservedObject var viewModel: TransactionsViewModel
    
    @State private var amount = ""
    @State private var selectedType: TransactionType = .expense
    @State private var selectedCategory = "Еда"
    @State private var comment = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationStack {
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
                        ForEach(viewModel.availableCategories, id: \.self) { category in
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
        
        let success = viewModel.addTransaction(
            amount: amount,
            type: selectedType,
            category: selectedCategory,
            comment: comment.isEmpty ? nil : comment,
            date: date
        )
        if success{
            dismiss()
        }
    }
}

#Preview {
    AddTransactionView(viewModel: TransactionsViewModel())
}

