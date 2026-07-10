//
//  MainView.swift
//  MoneyTracker
//
//  Created by Ilvina on 06.07.2026.
//

import Foundation
import SwiftUI

struct MainView: View {
    @State private var showAddTransaction = false
    @StateObject private var viewModel = TransactionsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Баланс
                    BalanceCard(
                        balance: viewModel.balance,
                        income: viewModel.totalIncome,
                        expense: viewModel.totalExpense,
                        currency: viewModel.selectedCurrency
                    )
                    
                    // MARK: - Кольцевая диаграмма
                    RingChartView(incomeRatio: viewModel.incomeRatio)
                        .frame(height: 200)
                    
                    // MARK: - Последние операции
                    RecentTransactionsView(
                        transactions: viewModel.lastFiveTransactions,
                        currency: viewModel.selectedCurrency
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
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: AllTransactionsView(viewModel: viewModel)) {
                        Image(systemName: "list.bullet")
                    }
                }
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
                    viewModel: viewModel
                )
            }
        }
        .onAppear {
            viewModel.updateCurrency()
        }
    }
}

#Preview {
    MainView()
}

