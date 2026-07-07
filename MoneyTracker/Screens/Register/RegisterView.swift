//
//  RegisterView.swift
//  MoneyTracker
//
//  Created by elina on 04.07.2026.
//

import SwiftUI

struct RegisterView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    let auth = AuthService.shared
    
    var body: some View {
        Form {
            Section("Новый аккаунт") {
                TextField("Имя пользователя", text: $username)
                    .autocapitalization(.none)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Пароль (мин. 6 символов)", text: $password)
                
                SecureField("Подтвердите пароль", text: $confirmPassword)
            }
            
            Section {
                Button {
                    register()
                } label: {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Зарегистрироваться")
                            .frame(maxWidth: .infinity)
                    }
                }
                .foregroundColor(.blue)
                .disabled(isLoading || !isFormValid)
            }
        }
        .navigationTitle("Регистрация")
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK") { }
        }
    }
    
    var isFormValid: Bool {
        !username.isEmpty &&
        !email.isEmpty &&
        password.count >= 6 &&
        password == confirmPassword
    }
    
    func register() {
        guard isFormValid else {
            alertMessage = "Проверьте правильность заполнения полей"
            showAlert = true
            return
        }
        
        isLoading = true
        
        auth.register(email: email, password: password, username: username) { result in
            isLoading = false
            
            switch result {
            case .success(let user):
                alertMessage = "Добро пожаловать, \(user.username)!"
                showAlert = true
                
                username = ""
                email = ""
                password = ""
                confirmPassword = ""
                
            case .failure(let error):
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}

#Preview {
    NavigationView {
        RegisterView()
    }
}
