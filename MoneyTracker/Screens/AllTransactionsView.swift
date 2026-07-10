//
//  AllTransactionsView.swift
//  MoneyTracker
//
//  Created by Ilvina on 09.07.2026.
//

import Foundation
import SwiftUI

struct AllTransactionsView: View {
    @ObservedObject var viewModel: TransactionsViewModel
    
    @State private var searchText = ""
    @State private var filterType: FilterType = .all
    
    enum FilterType: String, CaseIterable {
        case all = "Все"
        case income = "Доходы"
        case expense = "Расходы"
    }
    
    var filteredTransactions: [Transaction] {
        var result = viewModel.allTransactions
        
        switch filterType {
        case .all:
            break
        case .income:
            result = result.filter { $0.type == .income }
        case .expense:
            result = result.filter { $0.type == .expense }
        }
        
        if !searchText.isEmpty {
            result = result.filter { $0.category.localizedCaseInsensitiveContains(searchText) }
        }
        
        return result
    }
    
    var groupedTransactions: [(date: Date, transactions: [Transaction])] {
        let grouped = Dictionary(grouping: filteredTransactions) { transaction in
            Calendar.current.startOfDay(for: transaction.date)
        }
        
        return grouped
            .map { (date: $0.key, transactions: $0.value) }
            .sorted { $0.date > $1.date }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Поиск по категории", text: $searchText)
                        .textFieldStyle(.plain)
                    
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                Picker("Фильтр", selection: $filterType) {
                    ForEach(FilterType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
            }
            .padding(.vertical, 12)
            
            if filteredTransactions.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("Нет операций")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    if !searchText.isEmpty {
                        Text("Попробуйте изменить поиск")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(groupedTransactions, id: \.date) { group in
                        Section {
                            ForEach(group.transactions) { transaction in
                                TransactionRow(
                                    transaction: transaction,
                                    currency: viewModel.currentCurrency
                                )
                            }
                        } header: {
                            Text(formatDate(group.date))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Все операции")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.updateCurrency()
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        let viewModel = TransactionsViewModel()
        viewModel.transactions = [
            Transaction(amount: 1500, type: .income, category: "Зарплата", comment: "Аванс", date: Date()),
            Transaction(amount: 500, type: .expense, category: "Еда", comment: "Продукты", date: Date()),
        ]
        return AllTransactionsView(viewModel: viewModel)
    }
}
