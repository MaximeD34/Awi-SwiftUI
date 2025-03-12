//
//  APIClient.swift
//  Awi-SwiftUI
//
//  A generic networking client to handle HTTP requests to the RESTful API.
//  Utilizes URLSession and handles JSON encoding/decoding.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    private init() { }
    
    func request<T: Decodable>(url: URL,
                            method: String = "GET",
                            body: Data? = nil,
                            completion: @escaping (Result<T, Error>) -> Void) {
  var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Add JWT token if available
        if let token = TokenManager.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "APIClient", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "APIClient", code: -1, userInfo: nil)))
                return
            }
            
            // Print raw response data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw Response Data: \(jsonString)")
            } else {
                print("Failed to convert response data to string.")
            }
            
            do {
        let decoded = try JSONDecoder().decode(T.self, from: data)
        completion(.success(decoded))
    } catch {
        completion(.failure(error))
    }  
        }.resume()
    }
    
    func getCookie(named name: String) -> String? {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                if cookie.name == name {
                    return cookie.value
                }
            }
        }
        return nil
    }
}
