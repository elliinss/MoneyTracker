//
//  Models.swift
//  MoneyTracker
//
//  Created by elina on 04.07.2026.
//

import Foundation

enum TransactionType: String {
    case income = "Доход"
    case expense = "Расход"
}

struct Transaction: Identifiable {
    let id = UUID()
    let amount: Double
    let type: TransactionType
    let category: String
    let comment: String?
    let date: Date
}

enum Currency: String, CaseIterable {
    case rub = "₽"
    case usd = "$"
    case eur = "€"
}
struct AppUser {
    let id: String
    let email: String
    let username: String
}
enum AnalyticsPeriod: String, CaseIterable {
    case week = "Неделя"
    case month = "Месяц"
}
