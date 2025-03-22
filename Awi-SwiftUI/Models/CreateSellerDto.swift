import Foundation

struct CreateSellerDto: Codable {
    let name: String
    let email: String
    let tel: String
    let billing_address: String?
}
