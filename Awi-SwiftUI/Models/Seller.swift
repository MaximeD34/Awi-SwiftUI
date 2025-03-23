struct Seller: Identifiable, Codable, Hashable {  // Added Hashable conformance.
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
