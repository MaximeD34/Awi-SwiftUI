import Foundation
import SwiftUI

struct CreatePurchaseDto: Codable {
    let date: Date
    let game_item_instance_ids: [String]
    let id_client_public: String = "d05c2918-f035-46dd-a6be-1e093bb7a62f"
}

struct EmptyResponse: Decodable { }
