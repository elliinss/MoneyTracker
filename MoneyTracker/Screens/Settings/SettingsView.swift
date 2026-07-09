//
//  SettingsView.swift
//  MoneyTracker
//
//  Created by elina on 04.07.2026.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedCurrency: Currency
    
    @StateObject private var settingsManager: SettingsManager
    
    @State private var newCategory = ""
    
    @State private var showAlert = false
    @State private var alertText = ""
    
    @FocusState private var isTextFieldFocused: Bool
    
    init(settingsManager: SettingsManager = SettingsManager.shared) {
        self._settingsManager = StateObject(wrappedValue: settingsManager)
        self._selectedCurrency = State(initialValue: settingsManager.currentCurrency)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Валюта") {
                    Picker("Выберите валюту", selection: $selectedCurrency) {
                        Text("₽ Рубль").tag(Currency.rub)
                        Text("$ Доллар").tag(Currency.usd)
                        Text("€ Евро").tag(Currency.eur)
                    }
                    .pickerStyle(.menu)
                    .onChange(of: selectedCurrency) { _, newValue in
                        settingsManager.currentCurrency = newValue
                    }
                }
                
                Section("Категории") {
                    ForEach(settingsManager.categories, id: \.self) { category in
                        HStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 8, height: 8)
                            Text(category)
                        }
                    }
                    .onDelete { indexSet in
                        if let index = indexSet.first {
                            settingsManager.deleteCategory(at: index)
                        }
                    }
                
                    HStack {
                        TextField("Новая категория", text: $newCategory)
                            .focused($isTextFieldFocused)
                        
                        Button("Добавить") {
                            addCategory()
                        }
                        .disabled(newCategory.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
            .navigationTitle("Настройки")
            .alert(alertText, isPresented: $showAlert) {
                Button("OK") { }
            }
        }
    }
    
    func addCategory() {
        let name = newCategory.trimmingCharacters(in: .whitespaces)
        
        guard !name.isEmpty else { return }
        
        guard !settingsManager.categories.contains(name) else {
            alertText = "Категория '\(name)' уже есть"
            showAlert = true
            return
        }
        
        settingsManager.addCategory(name)
        newCategory = ""
        isTextFieldFocused = false
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
