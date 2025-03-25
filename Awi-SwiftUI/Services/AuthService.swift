//
//  AuthService.swift
//  Awi-SwiftUI
//
//  Wraps the authentication API calls (login) and handles JWT management.
//  Calls APIClient and updates TokenManager upon successful login.
//

import Foundation

enum AuthError: Error {
    case invalidCredentials
    case unknown
    case noAuthToken
    case dtoError(String) // New case for DTO errors
}

enum StringOrArray: Decodable {
    case string(String)
    case array([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let arrayValue = try? container.decode([String].self) {
            self = .array(arrayValue)
        } else {
            throw DecodingError.typeMismatch(StringOrArray.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected String or [String]"))
        }
    }
}

struct AuthResponse: Decodable {
    let message: StringOrArray?
    let errors: [String]?
    let error: String?
    let statusCode: Int?
}

class AuthService {
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let loginData = ["name": email, "password": password]
        guard let body = try? JSONSerialization.data(withJSONObject: loginData, options: []) else {
            completion(.failure(AuthError.unknown))
            return
        }
        
       APIClient.shared.request(url: Endpoints.login, method: "POST", body: body) { (result: Result<AuthResponse, Error>) in
            switch result {
            case .success(let authResponse):
                if let errors = authResponse.errors, !errors.isEmpty {
                    print("Login failed with DTO errors: \(errors)")
                    completion(.failure(AuthError.dtoError(errors.joined(separator: ", "))))
                    return
                }

                if authResponse.statusCode == 401 || authResponse.error != nil {
                    completion(.failure(AuthError.invalidCredentials))
                    return
                }

                if let authCookie = APIClient.shared.getCookie(named: "auth") {
                    TokenManager.shared.token = authCookie

                    switch authResponse.message {
                    case .string(let message):
                        completion(.success(message))
                    case .array(let messageArray):
                        completion(.success(messageArray.joined(separator: ", ")))
                    case .none:
                        completion(.failure(AuthError.unknown))
                    }

                } else {
                    completion(.failure(AuthError.noAuthToken))
                    print("Authentication successful, but no auth token found in cookies.")
                    return
                }
            case .failure(let error):
                print("error",error)
                completion(.failure(error))
            }
        }
    }
}
