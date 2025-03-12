//
//  Seller.swift
//  Awi-SwiftUI
//
//  Represents a seller profile managed by a Manager.
//  Contains details such as the seller’s name and the games they manage.
//

import Foundation

struct Seller: Codable, Identifiable {
    let id: UUID
    let name: String
    let assignedManagerID: UUID
    // Additional seller details can be added here.
}
