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
    // Published properties update the UI in response to changes.
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // The service layer handles the actual API call.
    private let authService = AuthService()
    
    func login() {
        isLoading = true
        errorMessage = nil
        
        print("test login")
        
        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    // Update auth state based on the logged in user.
                    print("yay")
                    self?.isAuthenticated = true
                    print(self?.isAuthenticated)
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
