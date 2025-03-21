import Foundation

struct Game: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let inventoryCount: Int  // Maps from nb_sale (quantity available)
    let condition: String
    let publicId: String  // id_game_inventory_item_public

    // New boardgame details fields (optional)
    let yearPublished: Int?
    let minPlayers: Int?
    let maxPlayers: Int?
    let minAge: Int?
    let minPlaytime: Int?
    let idEditorPublic: String?
    let editorName: String?   // New property for the editor's name

    enum CodingKeys: String, CodingKey {
        case id = "id_game_inventory_item"
        case publicId = "id_game_inventory_item_public"
        case price, status, nb_sale, nb_depot, bg
    }
    
    enum BGKeys: String, CodingKey {
        case name, description
        case yearPublished = "year_published"
        case minPlayers = "min_players"
        case maxPlayers = "max_players"
        case minAge = "min_age"
        case minPlaytime = "min_playtime"
        case idEditorPublic = "id_editor_public"
        case editor
    }
    
    enum BGEditorKeys: String, CodingKey {
        case name
    }
    
    // Custom initializer for Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        publicId = try container.decode(String.self, forKey: .publicId)
        price = try container.decode(Double.self, forKey: .price)
        condition = try container.decode(String.self, forKey: .status)
        inventoryCount = try container.decode(Int.self, forKey: .nb_sale)
        
        let bgContainer = try container.nestedContainer(keyedBy: BGKeys.self, forKey: .bg)
        title = try bgContainer.decode(String.self, forKey: .name)
        description = try bgContainer.decode(String.self, forKey: .description)
        yearPublished = try bgContainer.decodeIfPresent(Int.self, forKey: .yearPublished)
        minPlayers = try bgContainer.decodeIfPresent(Int.self, forKey: .minPlayers)
        maxPlayers = try bgContainer.decodeIfPresent(Int.self, forKey: .maxPlayers)
        minAge = try bgContainer.decodeIfPresent(Int.self, forKey: .minAge)
        minPlaytime = try bgContainer.decodeIfPresent(Int.self, forKey: .minPlaytime)
        idEditorPublic = try bgContainer.decodeIfPresent(String.self, forKey: .idEditorPublic)
        
        // Decode the nested "editor" object to get the editor's name.
        if bgContainer.contains(.editor) {
            let editorContainer = try bgContainer.nestedContainer(keyedBy: BGEditorKeys.self, forKey: .editor)
            editorName = try editorContainer.decodeIfPresent(String.self, forKey: .name)
        } else {
            editorName = nil
        }
    }
    
    // Implement encode(to:) for Encodable conformance.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(publicId, forKey: .publicId)
        try container.encode(price, forKey: .price)
        try container.encode(condition, forKey: .status)
        try container.encode(inventoryCount, forKey: .nb_sale)
        
        var bgContainer = container.nestedContainer(keyedBy: BGKeys.self, forKey: .bg)
        try bgContainer.encode(title, forKey: .name)
        try bgContainer.encode(description, forKey: .description)
        try bgContainer.encodeIfPresent(yearPublished, forKey: .yearPublished)
        try bgContainer.encodeIfPresent(minPlayers, forKey: .minPlayers)
        try bgContainer.encodeIfPresent(maxPlayers, forKey: .maxPlayers)
        try bgContainer.encodeIfPresent(minAge, forKey: .minAge)
        try bgContainer.encodeIfPresent(minPlaytime, forKey: .minPlaytime)
        try bgContainer.encodeIfPresent(idEditorPublic, forKey: .idEditorPublic)
        
        if let editorName = editorName {
            var editorContainer = bgContainer.nestedContainer(keyedBy: BGEditorKeys.self, forKey: .editor)
            try editorContainer.encode(editorName, forKey: .name)
        }
    }
    
    // Public initializer for creating sample data in previews or elsewhere.
    init(
        id: Int, title: String, description: String, price: Double,
        inventoryCount: Int, condition: String, publicId: String,
        yearPublished: Int? = nil, minPlayers: Int? = nil, maxPlayers: Int? = nil,
        minAge: Int? = nil, minPlaytime: Int? = nil, idEditorPublic: String? = nil,
        editorName: String? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.inventoryCount = inventoryCount
        self.condition = condition
        self.publicId = publicId
        self.yearPublished = yearPublished
        self.minPlayers = minPlayers
        self.maxPlayers = maxPlayers
        self.minAge = minAge
        self.minPlaytime = minPlaytime
        self.idEditorPublic = idEditorPublic
        self.editorName = editorName
    }
}

extension Game {
    var bgDetail: BGDetail {
        BGDetail(
            name: self.title,
            description: self.description,
            yearPublished: self.yearPublished,
            minPlayers: self.minPlayers,
            maxPlayers: self.maxPlayers,
            minAge: self.minAge,
            minPlaytime: self.minPlaytime,
            idEditorPublic: self.idEditorPublic,
            editorName: self.editorName
        )
    }
}