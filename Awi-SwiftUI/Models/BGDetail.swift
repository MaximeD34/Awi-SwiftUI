import Foundation

struct BGDetail: Identifiable, Codable {
    var id: Int? { nil }
    let name: String
    let description: String
    let yearPublished: Int?
    let minPlayers: Int?
    let maxPlayers: Int?
    let minAge: Int?
    let minPlaytime: Int?
    let idEditorPublic: String?
    let editorName: String?

    enum CodingKeys: String, CodingKey {
        case name, description
        case yearPublished = "year_published"
        case minPlayers = "min_players"
        case maxPlayers = "max_players"
        case minAge = "min_age"
        case minPlaytime = "min_playtime"
        case idEditorPublic = "id_editor_public"
        case editor
    }
    
    enum EditorKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        yearPublished = try container.decodeIfPresent(Int.self, forKey: .yearPublished)
        minPlayers = try container.decodeIfPresent(Int.self, forKey: .minPlayers)
        maxPlayers = try container.decodeIfPresent(Int.self, forKey: .maxPlayers)
        minAge = try container.decodeIfPresent(Int.self, forKey: .minAge)
        minPlaytime = try container.decodeIfPresent(Int.self, forKey: .minPlaytime)
        idEditorPublic = try container.decodeIfPresent(String.self, forKey: .idEditorPublic)
        
        if container.contains(.editor) {
            let editorContainer = try container.nestedContainer(keyedBy: EditorKeys.self, forKey: .editor)
            editorName = try editorContainer.decodeIfPresent(String.self, forKey: .name)
        } else {
            editorName = nil
        }
    }
    
    init(name: String, description: String,
         yearPublished: Int?, minPlayers: Int?, maxPlayers: Int?,
         minAge: Int?, minPlaytime: Int?,
         idEditorPublic: String?, editorName: String?) {
        self.name = name
        self.description = description
        self.yearPublished = yearPublished
        self.minPlayers = minPlayers
        self.maxPlayers = maxPlayers
        self.minAge = minAge
        self.minPlaytime = minPlaytime
        self.idEditorPublic = idEditorPublic
        self.editorName = editorName
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encodeIfPresent(yearPublished, forKey: .yearPublished)
        try container.encodeIfPresent(minPlayers, forKey: .minPlayers)
        try container.encodeIfPresent(maxPlayers, forKey: .maxPlayers)
        try container.encodeIfPresent(minAge, forKey: .minAge)
        try container.encodeIfPresent(minPlaytime, forKey: .minPlaytime)
        try container.encodeIfPresent(idEditorPublic, forKey: .idEditorPublic)
        var editorContainer = container.nestedContainer(keyedBy: EditorKeys.self, forKey: .editor)
        try editorContainer.encodeIfPresent(editorName, forKey: .name)
    }
}