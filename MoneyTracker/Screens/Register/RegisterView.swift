//
//  RegisterView.swift
//  MoneyTracker
//
//  Created by elina on 04.07.2026.
//

import SwiftUI

protocol AuthService {
    func register(email: String, password: String, username: String, completion: @escaping (Result<User, Error>) -> Void)
}

class RegisterViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isLoading = false
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
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
        
        authService.register(email: email, password: password, username: username) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let user):
                    self?.alertMessage = "Добро пожаловать, \(user.username)!"
                    self?.showAlert = true
                    
                    self?.username = ""
                    self?.email = ""
                    self?.password = ""
                    self?.confirmPassword = ""
                    
                case .failure(let error):
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
}

struct RegisterView: View {
    @StateObject private var viewModel: RegisterViewModel
    
    init(authService: AuthService = AuthServiceImpl()) {
        _viewModel = StateObject(wrappedValue: RegisterViewModel(authService: authService))
    }
    
    var body: some View {
        Form {
            Section("Новый аккаунт") {
                TextField("Имя пользователя", text: $viewModel.username)
                    .autocapitalization(.none)
                
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Пароль (мин. 6 символов)", text: $viewModel.password)
                
                SecureField("Подтвердите пароль", text: $viewModel.confirmPassword)
            }
            
            Section {
                Button {
                    viewModel.register()
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Зарегистрироваться")
                            .frame(maxWidth: .infinity)
                    }
                }
                .foregroundColor(.blue)
                .disabled(viewModel.isLoading || !viewModel.isFormValid)
            }
        }
        .navigationTitle("Регистрация")
        .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
            Button("OK") { }
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}
