//
//  TokenManager.swift
//  Awi-SwiftUI
//
//  Manages the JSON Web Token (JWT) for authentication.
//  Provides methods to store, retrieve, and validate the token.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    private init() { }
    
    private let tokenKey = "jwtToken"
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
    
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
