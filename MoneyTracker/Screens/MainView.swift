//
//  MainView.swift
//  MoneyTracker
//
//  Created by Ilvina on 06.07.2026.
//

import Foundation
import SwiftUI

struct MainView: View {
    @State private var transactions: [Transaction] = []
    @State private var showAddTransaction = false
    @State private var selectedCurrency: Currency = SettingsManager.shared.currentCurrency
    
    private var totalIncome: Double {
        transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var totalExpense: Double {
        transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var balance: Double {
        totalIncome - totalExpense
    }
    
    private var incomeRatio: Double {
        let total = totalIncome + totalExpense
        guard total > 0 else { return 0.5 }
        return totalIncome / total
    }
    
    private var lastFiveTransactions: [Transaction] {
        Array(transactions.sorted { $0.date > $1.date }.prefix(5))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Баланс
                    BalanceCard(
                        balance: balance,
                        income: totalIncome,
                        expense: totalExpense,
                        currency: selectedCurrency
                    )
                    
                    // MARK: - Кольцевая диаграмма
                    RingChartView(incomeRatio: incomeRatio)
                        .frame(height: 200)
                    
                    // MARK: - Последние операции
                    RecentTransactionsView(
                        transactions: lastFiveTransactions,
                        currency: selectedCurrency
                    )
                    
                    Spacer()
                        .frame(height: 80)
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .navigationTitle("Money Tracker")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                // MARK: - Кнопка добавления
                AddButton {
                    showAddTransaction = true
                }
                .padding(.trailing, 24)
                .padding(.bottom, 24)
            }
            .sheet(isPresented: $showAddTransaction) {
                AddTransactionView(
                    transactions: $transactions,
                    selectedCurrency: $selectedCurrency
                )
            }
        }
        .onAppear {
        }
        .onChange(of: SettingsManager.shared.currentCurrency) { _, newValue in
            selectedCurrency = newValue
        }
    }
}

// MARK: - Компонент: Карточка баланса
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

// MARK: - Компонент: Кольцевая диаграмма
struct RingChartView: View {
    let incomeRatio: Double
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                    .frame(width: 150, height: 150)
                
                Circle()
                    .trim(from: 0, to: incomeRatio)
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                
                Circle()
                    .trim(from: incomeRatio, to: 1)
                    .stroke(Color.red, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 4) {
                    Text("Соотношение")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(Int(incomeRatio * 100))% / \(Int((1 - incomeRatio) * 100))%")
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
            
            HStack(spacing: 24) {
                Label("Доходы", systemImage: "circle.fill")
                    .foregroundColor(.green)
                    .font(.caption)
                
                Label("Расходы", systemImage: "circle.fill")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            .padding(.top, 8)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// MARK: Список последних операций
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

// MARK: Строка транзакции
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

// MARK: Кнопка добавления
struct AddButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.blue)
                .clipShape(Circle())
        }
    }
}

#Preview {
    MainView()
}

