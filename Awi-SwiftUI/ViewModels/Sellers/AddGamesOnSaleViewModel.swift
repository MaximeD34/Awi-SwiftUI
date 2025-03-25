import Foundation
import Combine

struct SaleGame: Identifiable, Codable {
    let id: UUID = UUID()
    let name: String
    let quality: String
    var quantityOnDepot: Int
    let sellingPrice: Double
    var quantityToSell: Int = 0
    let idTypeBoardGamePublic: String
    let idGameInventoryItemPublic: String

    enum CodingKeys: String, CodingKey {
        case sellingPrice = "price"
        case quality = "status"
        case quantityOnDepot = "nb_depot"
        case idTypeBoardGamePublic = "id_bg_public"
        case idGameInventoryItemPublic = "id_game_inventory_item_public"
        case bg
    }

    enum BGKeys: String, CodingKey {
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sellingPrice = try container.decode(Double.self, forKey: .sellingPrice)
        quality = try container.decode(String.self, forKey: .quality)
        quantityOnDepot = try container.decode(Int.self, forKey: .quantityOnDepot)
        idTypeBoardGamePublic = try container.decode(String.self, forKey: .idTypeBoardGamePublic)
        idGameInventoryItemPublic = try container.decode(String.self, forKey: .idGameInventoryItemPublic)
        let bgContainer = try container.nestedContainer(keyedBy: BGKeys.self, forKey: .bg)
        name = try bgContainer.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sellingPrice, forKey: .sellingPrice)
        try container.encode(quality, forKey: .quality)
        try container.encode(quantityOnDepot, forKey: .quantityOnDepot)
        try container.encode(idTypeBoardGamePublic, forKey: .idTypeBoardGamePublic)
        try container.encode(idGameInventoryItemPublic, forKey: .idGameInventoryItemPublic)
        var bgContainer = container.nestedContainer(keyedBy: BGKeys.self, forKey: .bg)
        try bgContainer.encode(name, forKey: .name)
    }
}

struct SaleRequest: Codable {
    let discount: Int
    let id_seller_public: String
    let games: [SaleGameRequest]
}

struct SaleGameRequest: Codable {
    let variation_stock: Int
    let id_type_boardgame_public: String
    let status: String
    let price: Double
    let id_game_inventory_item_public: String
}

class AddGamesOnSaleViewModel: ObservableObject {
    @Published var games: [SaleGame] = []

    private let saleService = SaleService()  // New sale service instance
    
    func fetchGames(for seller: Seller) {
        let url = Endpoints.baseURL.appendingPathComponent("storage/\(seller.idSellerPublic)")
        APIClient.shared.request(url: url) { (result: Result<[SaleGame], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedGames):
                    // Accept only games with some available units.
                    self.games = fetchedGames.filter { $0.quantityOnDepot > 0 }
                case .failure(let error):
                    print("Error fetching storage data: \(error)")
                }
            }
        }
    }
    
    func confirmSale(for seller: Seller, completion: @escaping (Result<Void, Error>) -> Void) {
        let saleItems = games.filter { $0.quantityToSell > 0 }
        guard !saleItems.isEmpty else {
            completion(.failure(NSError(domain: "No sale items selected", code: -1, userInfo: nil)))
            return
        }
        let saleData = SaleRequest(
            discount: 0,
            id_seller_public: seller.idSellerPublic,
            games: saleItems.map { item in
                SaleGameRequest(
                    variation_stock: item.quantityToSell,
                    id_type_boardgame_public: item.idTypeBoardGamePublic,
                    status: item.quality,
                    price: item.sellingPrice,
                    id_game_inventory_item_public: item.idGameInventoryItemPublic
                )
            }
        )
        
        saleService.submitSale(request: saleData, completion: completion)
    }
}
