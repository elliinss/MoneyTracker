//
//  SettingsManager.swift
//  MoneyTracker
//
//  Created by elina on 04.07.2026.
//

import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    private let defaults = UserDefaults.standard
    
    var currentCurrency: Currency {
        get {
            if let raw = defaults.string(forKey: "currency"),
               let currency = Currency(rawValue: raw) {
                return currency
            }
            return .rub
        }
        set {
            defaults.set(newValue.rawValue, forKey: "currency")
        }
    }
    
    var categories: [String] {
        get {
            return defaults.stringArray(forKey: "categories") ?? ["Еда", "Транспорт", "Кафе", "Зарплата"]
        }
        set {
            defaults.set(newValue, forKey: "categories")
        }
    }
    
    func addCategory(_ name: String) {
        var list = categories
        list.append(name)
        categories = list
    }
    
    func deleteCategory(at index: Int) {
        var list = categories
        guard index < list.count else { return }
        list.remove(at: index)
        categories = list
    }
}
