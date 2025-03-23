import Foundation

struct ClientPurchase: Identifiable, Decodable {
    var id: Int { id_purchase }
    
    let id_purchase: Int
    let id_purchase_public: String
    let date: String
    let id_client_public: String
    let id_manager_public: String
}
