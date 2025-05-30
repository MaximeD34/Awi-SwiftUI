//
//  Endpoints.swift
//  Awi-SwiftUI
//
//  Contains the definitions of RESTful endpoints used by the APIClient.
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
        return baseURL.appendingPathComponent("game-item-instance/serial/\(serial)/sale") //only for games currently on sale
    }
    
    static var purchase: URL {
        return baseURL.appendingPathComponent("purchase")
    }
    
    static func gameItemInstances(publicId: String) -> URL {
        return baseURL.appendingPathComponent("game-inventory-item/\(publicId)/instances")
    }
    
}
