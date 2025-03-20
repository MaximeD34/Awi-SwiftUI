import Foundation

struct Game: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let inventoryCount: Int  // Now maps from nb_sale (quantity available)
    let condition: String
    let publicId: String  // id_game_inventory_item_public

    enum CodingKeys: String, CodingKey {
        case id = "id_game_inventory_item"
        case publicId = "id_game_inventory_item_public"
        case price, status, nb_sale, nb_depot, bg
    }
    
    enum BGKeys: String, CodingKey {
        case name, description
    }
    
    // Custom init for Decodable: map quantity available from "nb_sale"
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        publicId = try container.decode(String.self, forKey: .publicId)
        price = try container.decode(Double.self, forKey: .price)
        condition = try container.decode(String.self, forKey: .status)
        // Map available quantity from nb_sale instead of nb_depot
        inventoryCount = try container.decode(Int.self, forKey: .nb_sale)
        
        let bgContainer = try container.nestedContainer(keyedBy: BGKeys.self, forKey: .bg)
        title = try bgContainer.decode(String.self, forKey: .name)
        description = try bgContainer.decode(String.self, forKey: .description)
    }
    
    // Implement encode(to:) to conform to Encodable using "nb_sale" for the quantity.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(publicId, forKey: .publicId)
        try container.encode(price, forKey: .price)
        try container.encode(condition, forKey: .status)
        // Encode available quantity using nb_sale key
        try container.encode(inventoryCount, forKey: .nb_sale)
        
        var bgContainer = container.nestedContainer(keyedBy: BGKeys.self, forKey: .bg)
        try bgContainer.encode(title, forKey: .name)
        try bgContainer.encode(description, forKey: .description)
    }
    
    // Public initializer for creating sample data in previews or elsewhere.
    init(id: Int, title: String, description: String, price: Double, inventoryCount: Int, condition: String, publicId: String) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.inventoryCount = inventoryCount
        self.condition = condition
        self.publicId = publicId
    }
}