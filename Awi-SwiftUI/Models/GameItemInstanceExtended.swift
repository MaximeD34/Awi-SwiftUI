import Foundation

struct GameItemInstanceExtended: Decodable, Identifiable {
    var id: Int { idGameItemInstance }
    
    let idGameItemInstance: Int
    let idGameItemInstancePublic: String
    let serialNumber: String
    let saleStartDay: Date?
    let isOnSale: Bool
    let idGameInventoryItemPublic: String
    let idPurchasePublic: String?
    let purchase: PurchaseExtended?
    let gameInventoryItem: GameInventoryItemExtended

    enum CodingKeys: String, CodingKey {
        case idGameItemInstance = "id_game_item_instance"
        case idGameItemInstancePublic = "id_game_item_instance_public"
        case serialNumber = "serial_number"
        case saleStartDay = "sale_start_day"
        case isOnSale = "is_on_sale"
        case idGameInventoryItemPublic = "id_game_inventory_item_public"
        case idPurchasePublic = "id_purchase_public"
        case purchase
        case gameInventoryItem
    }
}

struct PurchaseExtended: Decodable {
    let idPurchase: Int
    let idPurchasePublic: String
    let date: Date?
    let idClientPublic: String
    let idManagerPublic: String
    // Additional client details can be added later if needed.
    
    enum CodingKeys: String, CodingKey {
        case idPurchase = "id_purchase"
        case idPurchasePublic = "id_purchase_public"
        case date
        case idClientPublic = "id_client_public"
        case idManagerPublic = "id_manager_public"
    }
}

struct GameInventoryItemExtended: Decodable {
    let id: Int
    let idGameInventoryItemPublic: String
    let price: Double
    let status: String
    let idSellerPublic: String
    let idBgPublic: String
    let nbSale: Int
    let nbDepot: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id_game_inventory_item"
        case idGameInventoryItemPublic = "id_game_inventory_item_public"
        case price, status
        case idSellerPublic = "id_seller_public"
        case idBgPublic = "id_bg_public"
        case nbSale = "nb_sale"
        case nbDepot = "nb_depot"
    }
}
