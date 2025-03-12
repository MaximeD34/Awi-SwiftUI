//
//  Game.swift
//  Awi-SwiftUI
//
//  Represents a board game available for sale.
//  Includes details such as the name, price, inventory count, and description.
//

import Foundation

struct Game: Codable, Identifiable {
    let id: UUID
    let title: String
    let description: String
    let price: Double
    let inventoryCount: Int
}
