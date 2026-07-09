//
//  RingChartView.swift
//  MoneyTracker
//
//  Created by Ilvina on 07.07.2026.
//

import Foundation
import SwiftUI

struct RingChartView: View {
    let incomeRatio: Double
    @State private var isShowingAnalytics = false

    
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
            .onTapGesture {
                isShowingAnalytics = true
            }
            .sheet(isPresented: $isShowingAnalytics) {
                NavigationStack {
                    AnalyticsView()
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
