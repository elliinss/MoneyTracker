//
//  ContentView.swift
//  MoneyTracker
//
//  Created by elina on 04.07.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Money Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    NavigationLink("Настройки") {
                        SettingsView()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    NavigationLink("Вход") {
                        LoginView()
                    }
                    .buttonStyle(.borderedProminent)
                                        
                    
                    NavigationLink("Регистрация") {
                        RegisterView()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
