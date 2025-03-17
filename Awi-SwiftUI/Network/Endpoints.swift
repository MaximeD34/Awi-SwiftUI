//
//  Endpoints.swift
//  Awi-SwiftUI
//
//  Contains the definitions of RESTful endpoints used by the APIClient.
//  Adjust the endpoints according to your backend's specification.
//

import Foundation

struct Endpoints {
    
    static let baseURL = URL(string: Constants.API_BASE_URL)!

    
    static var login: URL {
        return baseURL.appendingPathComponent("auth/login")
    }
    
    static var games: URL {
        return baseURL.appendingPathComponent("games")
    }
    
    static func seller(withID id: UUID) -> URL {
        return baseURL.appendingPathComponent("sellers/\(id.uuidString)")
    }
    
    static func gameItemInstance(serial: String) -> URL {
        return baseURL.appendingPathComponent("game-item-instance/serial/\(serial)")
    }

    static var purchase: URL {
        return baseURL.appendingPathComponent("purchase")
    }
    
    // Define other endpoints as needed.
}
