//
//  LoginView.swift
//  MoneyTracker
//
//  Created by elina on 04.07.2026.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @Binding var isLoggedIn: Bool
    
    let auth = AuthService.shared
    
    var body: some View {
        Form {
            Section("Вход в аккаунт") {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Пароль", text: $password)
            }
            
            Section {
                Button {
                    login()
                } label: {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Войти")
                            .frame(maxWidth: .infinity)
                    }
                }
                .foregroundColor(.blue)
                .disabled(isLoading || email.isEmpty || password.isEmpty)
            }
            
            Section {
                NavigationLink("Нет аккаунта? Зарегистрироваться") {
                    RegisterView()
                }
            }
        }
        .navigationTitle("Вход")
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK") { }
        }
    }
    
    func login() {
        isLoading = true
        
        auth.login(email: email, password: password) { result in
            isLoading = false
            
            switch result {
            case .success(let user):
                alertMessage = "Добро пожаловать, \(user.username)!"
                showAlert = true
                isLoggedIn = true
                
            case .failure(let error):
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}

#Preview {
    NavigationView {
        LoginView(isLoggedIn: .constant(false))
    }
}
