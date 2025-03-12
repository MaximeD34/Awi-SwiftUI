//
//  Transaction.swift
//  Awi-SwiftUI
//
//  Represents a transaction record, such as a deposit, a game being put on sale,
//  or a sale transaction. It captures necessary information like the seller, game,
//  and quantity involved.
//

import Foundation

enum TransactionType: String, Codable {
    case deposit
    case sale
}

struct Transaction: Codable, Identifiable {
    let id: UUID
    let sellerID: UUID
    let gameID: UUID
    let type: TransactionType
    let quantity: Int
    let date: Date
}
