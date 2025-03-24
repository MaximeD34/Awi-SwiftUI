import Foundation

struct CreateClientDto: Encodable {
    let address: String
    let num: String
    let email: String
    let name: String
    let id_town_public: String
}
