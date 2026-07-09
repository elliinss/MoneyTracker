//
//  LoginView.swift
//  MoneyTracker
//
//  Created by elina on 04.07.2026.
//

import SwiftUI

protocol AuthService {
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func logout() throws
    var currentUser: User? { get }
}

@Observable
final class LoginViewModel {
    var email = ""
    var password = ""
    var showAlert = false
    var alertMessage = ""
    var isLoading = false
    var isLoggedIn = false
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    func login() {
        isLoading = true
        
        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let user):
                    self?.alertMessage = "Добро пожаловать, \(user.username)!"
                    self?.showAlert = true
                    self?.isLoggedIn = true
                    
                case .failure(let error):
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
    
    func logout() {
        try? authService.logout()
        isLoggedIn = false
    }
}

struct LoginView: View {
    @State private var viewModel: LoginViewModel
    
    init(authService: AuthService = AuthServiceImpl()) {
        _viewModel = State(initialValue: LoginViewModel(authService: authService))
    }
    
    var body: some View {
        Form {
            Section("Вход в аккаунт") {
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Пароль", text: $viewModel.password)
            }
            
            Section {
                Button {
                    viewModel.login()
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Войти")
                            .frame(maxWidth: .infinity)
                    }
                }
                .foregroundColor(.blue)
                .disabled(viewModel.isLoading || !viewModel.isFormValid)
            }
            
            Section {
                NavigationLink("Нет аккаунта? Зарегистрироваться") {
                    RegisterView()
                }
            }
        }
        .navigationTitle("Вход")
        .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
            Button("OK") { }
        }
        .fullScreenCover(isPresented: $viewModel.isLoggedIn) {
            VStack(spacing: 20) {
                Text("Добро пожаловать!")
                    .font(.largeTitle)
                    .padding()
                
                if let user = viewModel.authService?.currentUser {
                    Text("Вы вошли как: \(user.username)")
                        .font(.headline)
                }
                
                Button("Выйти") {
                    viewModel.logout()
                }
                .foregroundColor(.red)
                .padding()
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
