import Foundation

struct SellerStats: Codable, Identifiable {
    var id: String { id_seller_public }
    
    let id_seller_public: String
    let name: String
    let email: String?
    let tel: String?
    let billing_address: String?
    
    let total_turnover: Double
    let total_commissions: Double
    let total_deposits: Double
    let sold_games_count: Int
    let unsold_games_count: Int
}
