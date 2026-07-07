//
//  SettingsView.swift
//  MoneyTracker
//
//  Created by elina on 04.07.2026.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedCurrency: Currency = SettingsManager.shared.currentCurrency
    
    @State private var categories: [String] = SettingsManager.shared.categories
    
    @State private var newCategory = ""
    
    @State private var showAlert = false
    @State private var alertText = ""
    
    var body: some View {
        Form {
            Section("Валюта") {
                Picker("Выберите валюту", selection: $selectedCurrency) {
                    Text("₽ Рубль").tag(Currency.rub)
                    Text("$ Доллар").tag(Currency.usd)
                    Text("€ Евро").tag(Currency.eur)
                }
                .pickerStyle(.menu)
                .onChange(of: selectedCurrency) { _, newValue in
                    SettingsManager.shared.currentCurrency = newValue
                }
            }
            
            Section("Категории") {
                ForEach(categories, id: \.self) { category in
                    HStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 8, height: 8)
                        Text(category)
                    }
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        SettingsManager.shared.deleteCategory(at: index)
                        categories = SettingsManager.shared.categories
                    }
                }
                
                HStack {
                    TextField("Новая категория", text: $newCategory)
                    
                    Button("Добавить") {
                        addCategory()
                    }
                    .disabled(newCategory.isEmpty)
                }
            }
        }
        .navigationTitle("Настройки")
        .alert(alertText, isPresented: $showAlert) {
            Button("OK") { }
        }
    }
    
    func addCategory() {
        let name = newCategory.trimmingCharacters(in: .whitespaces)
        
        guard !name.isEmpty else { return }
        
        guard !categories.contains(name) else {
            alertText = "Категория '\(name)' уже есть"
            showAlert = true
            return
        }
        
        SettingsManager.shared.addCategory(name)
        categories = SettingsManager.shared.categories
        newCategory = ""
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}
