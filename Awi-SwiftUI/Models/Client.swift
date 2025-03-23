import Foundation

struct Client: Identifiable, Decodable {
    var id: Int { id_client }
    
    let id_client: Int
    let id_client_public: String
    let address: String
    let num: String
    let email: String
    let name: String
    let id_town_public: String
}
