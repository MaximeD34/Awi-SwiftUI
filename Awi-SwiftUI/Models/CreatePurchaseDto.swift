import Foundation

struct CreatePurchaseDto: Codable {
    let date: Date
    let game_item_instance_ids: [String]
    let id_client_public: String
}
