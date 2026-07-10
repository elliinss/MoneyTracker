//
//  AnalyticsView.swift
//  MoneyTracker
//
//  Created by elina on 06.07.2026.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    @ObservedObject var viewModel: TransactionsViewModel
    @State private var selectedPeriod: AnalyticsPeriod = .week
    
    private var totalSpent: Double {
        viewModel.transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var dailyData: [(day: String, amount: Double)] {
        let calendar = Calendar.current
        let expenses = viewModel.transactions.filter { $0.type == .expense }
        
        let grouped = Dictionary(grouping: expenses) { transaction in
            calendar.component(.day, from: transaction.date)
        }
        
        let sortedKeys = grouped.keys.sorted()
        let last7Keys = sortedKeys.suffix(7)
        
        return last7Keys.map { day in
            let total = grouped[day]?.reduce(0) { $0 + $1.amount } ?? 0
            return (day: "\(day)", amount: total)
        }
    }
    
    private var categoryData: [(category: String, amount: Double, color: Color)] {
        let expenses = viewModel.transactions.filter { $0.type == .expense }
        
        let grouped = Dictionary(grouping: expenses) { $0.category }
        
        let colors: [String: Color] = [
            "Еда": .blue,
            "Транспорт": .green,
            "Кафе": .orange,
            "Зарплата": .purple,
            "Развлечения": .red,
            "Покупки": .yellow,
            "Здоровье": .pink,
            "Образование": .indigo,
            "Коммуналка": .teal,
            "Связь": .mint
        ]
        
        return grouped.map { category, transactions in
            let total = transactions.reduce(0) { $0 + $1.amount }
            let color = colors[category] ?? .gray
            return (category: category, amount: total, color: color)
        }
        .sorted { $0.amount > $1.amount }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Picker("Период", selection: $selectedPeriod) {
                    Text("Неделя").tag(AnalyticsPeriod.week)
                    Text("Месяц").tag(AnalyticsPeriod.month)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Всего потрачено")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\(Int(totalSpent)) \(viewModel.selectedCurrency.rawValue)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                if !dailyData.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Расходы по дням")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Chart {
                            ForEach(dailyData.indices, id: \.self) { index in
                                BarMark(
                                    x: .value("День", dailyData[index].day),
                                    y: .value("Сумма", dailyData[index].amount)
                                )
                                .foregroundStyle(Color.blue.gradient)
                            }
                        }
                        .frame(height: 180)
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                } else {
                    emptyStateView("Нет данных за выбранный период")
                }
                
                if !categoryData.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Расходы по категориям")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: 20) {
                            Chart {
                                ForEach(categoryData.indices, id: \.self) { index in
                                    SectorMark(
                                        angle: .value("Сумма", categoryData[index].amount),
                                        innerRadius: .ratio(0.5)
                                    )
                                    .foregroundStyle(categoryData[index].color)
                                }
                            }
                            .frame(width: 130, height: 130)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(categoryData.indices, id: \.self) { index in
                                    HStack {
                                        Circle()
                                            .fill(categoryData[index].color)
                                            .frame(width: 10, height: 10)
                                        Text(categoryData[index].category)
                                            .font(.subheadline)
                                        Spacer()
                                        Text("\(Int(categoryData[index].amount)) \(viewModel.selectedCurrency.rawValue)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                } else {
                    emptyStateView("Нет данных по категориям")
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Аналитика")
        .background(Color(.systemGroupedBackground))
    }
    
    @ViewBuilder
    private func emptyStateView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text(message)
                .foregroundColor(.gray)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        let viewModel = TransactionsViewModel()
        viewModel.transactions = [
            Transaction(amount: 1500, type: .expense, category: "Еда", comment: nil, date: Date()),
            Transaction(amount: 500, type: .expense, category: "Транспорт", comment: nil, date: Date()),
            Transaction(amount: 2000, type: .expense, category: "Еда", comment: nil, date: Date()),
            Transaction(amount: 3000, type: .income, category: "Зарплата", comment: nil, date: Date()),
            Transaction(amount: 1000, type: .expense, category: "Кафе", comment: nil, date: Date()),
            Transaction(amount: 800, type: .expense, category: "Развлечения", comment: nil, date: Date()),
        ]
        return AnalyticsView(viewModel: viewModel)
    }
}
