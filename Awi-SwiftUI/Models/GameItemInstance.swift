import Foundation

struct GameItemInstance: Decodable, Identifiable {
    let id: Int
    let idGameItemInstancePublic: String
    let serialNumber: String
    let saleStartDay: Date?
    let isOnSale: Bool
    let gameInventoryItem: GameInventoryItem

    enum CodingKeys: String, CodingKey {
        case id = "id_game_item_instance"
        case idGameItemInstancePublic = "id_game_item_instance_public"
        case serialNumber = "serial_number"
        case saleStartDay = "sale_start_day"
        case isOnSale = "is_on_sale"
        case gameInventoryItem
    }
}

struct GameInventoryItem: Decodable {
    let id: Int
    let idGameInventoryItemPublic: String
    let price: Double
    let status: String
    let seller: Seller
    let bg: BoardGame

    enum CodingKeys: String, CodingKey {
        case id = "id_game_inventory_item"
        case idGameInventoryItemPublic = "id_game_inventory_item_public"
        case price, status, seller, bg
    }
}

struct Seller: Decodable, Identifiable {
    let id: Int
    let idSellerPublic: String
    let name: String
    let email: String?
    let tel: String?
    let billingAddress: String?

    enum CodingKeys: String, CodingKey {
        case id = "id_seller"
        case idSellerPublic = "id_seller_public"
        case name, email, tel
        case billingAddress = "billing_address"
    }
}

struct BoardGame: Decodable {
    let id: Int
    let idBgPublic: String
    let name: String
    let description: String?
    let yearPublished: Int?
    let minPlayers: Int?
    let maxPlayers: Int?
    let minAge: Int?
    let minPlaytime: Int?
    let idEditorPublic: String?

    enum CodingKeys: String, CodingKey {
        case id = "id_bg"
        case idBgPublic = "id_bg_public"
        case name, description
        case yearPublished = "year_published"
        case minPlayers = "min_players"
        case maxPlayers = "max_players"
        case minAge = "min_age"
        case minPlaytime = "min_playtime"
        case idEditorPublic = "id_editor_public"
    }
}
