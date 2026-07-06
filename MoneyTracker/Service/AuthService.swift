//
//  AuthService.swift
//  MoneyTracker
//
//  Created by elina on 04.07.2026.
//

import Foundation
import FirebaseAuth

class AuthService {
    static let shared = AuthService()
    private let auth = Auth.auth()
    
    var currentUser: AppUser? {
        guard let firebaseUser = auth.currentUser else { return nil }
        return AppUser(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? "",
            username: firebaseUser.displayName ?? "User"
        )
    }
    
    func register(email: String, password: String, username: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = result?.user else {
                let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Ошибка создания пользователя"])
                completion(.failure(error))
                return
            }
            
            let changeRequest = firebaseUser.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let user = AppUser(id: firebaseUser.uid, email: email, username: username)
                completion(.success(user))
            }
        }
    }
    func login(email: String, password: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = result?.user else {
                let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Ошибка входа"])
                completion(.failure(error))
                return
            }
            
            let user = AppUser(
                id: firebaseUser.uid,
                email: firebaseUser.email ?? email,
                username: firebaseUser.displayName ?? "User"
            )
            completion(.success(user))
        }
    }
    
    func logout() throws {
        try auth.signOut()
    }
}
