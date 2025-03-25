//
//  LoginViewModel.swift
//  Awi-SwiftUI
//
//  Handles login logic and manages authentication state.
//  Interacts with AuthService to authenticate users using a RESTful API.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = "Admin"
    @Published var password: String = "adminpassword"
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let authService = AuthService()
    
    func login() {
        isLoading = true
        errorMessage = nil
        
        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(_):
                    self?.isAuthenticated = true
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
