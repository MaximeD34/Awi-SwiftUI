import Foundation

struct DepositItem: Identifiable, Codable {
    let id: UUID = UUID()
    let gameId: String       // corresponds to id_bg_public from BoardGame
    let name: String
    let quality: String
    var quantity: Int
    let price: Double
}

struct DepositGame: Codable {
    let stock: Int
    let id_type_boardgame_public: String
    let status: String
    let price: Double
}

struct DepositRequest: Codable {
    let discount: Int
    let id_seller_public: String
    let games: [DepositGame]
}
