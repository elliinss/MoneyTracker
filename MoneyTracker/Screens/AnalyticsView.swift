//
//  AnalyticsView.swift
//  MoneyTracker
//
//  Created by elina on 06.07.2026.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    @State private var selectedPeriod: AnalyticsPeriod = .week
    @State private var totalSpent: Double = 12500
    
    private let dailyData: [(day: String, amount: Double)] = [
        ("1", 1200), ("2", 800), ("3", 2400), ("4", 600),
        ("5", 1800), ("6", 3000), ("7", 900)
    ]
    
    private let categoryData: [(category: String, amount: Double, color: Color)] = [
        ("Еда", 4500, .blue),
        ("Транспорт", 2500, .green),
        ("Кафе", 3000, .orange),
        ("Зарплата", 2500, .purple)
    ]
    
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
                    
                    Text("\(Int(totalSpent)) ₽")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
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
                                    Text("\(Int(categoryData[index].amount)) ₽")
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
            }
            .padding(.vertical)
        }
        .navigationTitle("Аналитика")
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    NavigationStack {
        AnalyticsView()
    }
}
