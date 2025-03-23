import Foundation

struct PurchaseBoardGame: Decodable {
    let id_bg: Int
    let id_bg_public: String
    let name: String
    let description: String
    let year_published: Int
    let min_players: Int
    let max_players: Int
    let min_age: Int
    let min_playtime: Int
    let id_editor_public: String
    
    enum CodingKeys: String, CodingKey {
        case id_bg = "id_bg"
        case id_bg_public = "id_bg_public"
        case name, description
        case year_published = "year_published"
        case min_players = "min_players"
        case max_players = "max_players"
        case min_age = "min_age"
        case min_playtime = "min_playtime"
        case id_editor_public = "id_editor_public"
    }
}

struct PurchaseGameInventoryItem: Decodable {
    let id: Int
    let idGameInventoryItemPublic: String
    let price: Double
    let status: String
    let idSellerPublic: String
    let idBgPublic: String
    let nbSale: Int
    let nbDepot: Int
    let bg: PurchaseBoardGame?  // Use our new BoardGame model
    
    enum CodingKeys: String, CodingKey {
        case id = "id_game_inventory_item"
        case idGameInventoryItemPublic = "id_game_inventory_item_public"
        case price, status
        case idSellerPublic = "id_seller_public"
        case idBgPublic = "id_bg_public"
        case nbSale = "nb_sale"
        case nbDepot = "nb_depot"
        case bg
    }
}

struct PurchaseGameItemInstance: Decodable, Identifiable {
    var id: Int { idGameItemInstance }
    
    let idGameItemInstance: Int
    let idGameItemInstancePublic: String
    let serialNumber: String
    let saleStartDay: Date?
    let isOnSale: Bool
    let idGameInventoryItemPublic: String
    let idPurchasePublic: String?
    let gameInventoryItem: PurchaseGameInventoryItem

    enum CodingKeys: String, CodingKey {
        case idGameItemInstance = "id_game_item_instance"
        case idGameItemInstancePublic = "id_game_item_instance_public"
        case serialNumber = "serial_number"
        case saleStartDay = "sale_start_day"
        case isOnSale = "is_on_sale"
        case idGameInventoryItemPublic = "id_game_inventory_item_public"
        case idPurchasePublic = "id_purchase_public"
        case gameInventoryItem
    }
}
