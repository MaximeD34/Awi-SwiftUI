import Foundation
import Combine

// Structure representing the raw storage data from the backend.
struct StorageGame: Decodable, Identifiable {
    var id: UUID { UUID() }
    let idGameInventoryItemPublic: String
    let price: Double
    let status: String
    let nb_depot: Int
    let nb_sale: Int
    let bg: BG

    struct BG: Decodable {
        let name: String
    }

    enum CodingKeys: String, CodingKey {
        case idGameInventoryItemPublic = "id_game_inventory_item_public"
        case price, status, nb_depot, nb_sale, bg
    }
}

// The model used for the UI in the "Take Back" flow.
struct RetrieveGame: Identifiable {
    let id = UUID()
    let name: String
    let quality: String
    var quantityAvailable: Int
    let sellingPrice: Double
    var quantityToTakeBack: Int = 0
    let idGameInventoryItemPublic: String
    let source: String  // "stock" for depot, "sale" for sale
}

class TakeBackGameViewModel: ObservableObject {
    @Published var depotGames: [RetrieveGame] = []
    @Published var saleGames: [RetrieveGame] = []
    
    private let retrieveService = RetrieveService()
    
    func fetchGames(for seller: Seller) {
        let url = Endpoints.baseURL.appendingPathComponent("storage/\(seller.idSellerPublic)")
        APIClient.shared.request(url: url) { (result: Result<[StorageGame], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let storageGames):
                    self.depotGames = storageGames
                        .filter { $0.nb_depot > 0 }
                        .map { game in
                            RetrieveGame(name: game.bg.name,
                                         quality: game.status,
                                         quantityAvailable: game.nb_depot,
                                         sellingPrice: game.price,
                                         idGameInventoryItemPublic: game.idGameInventoryItemPublic,
                                         source: "stock")
                        }
                    self.saleGames = storageGames
                        .filter { $0.nb_sale > 0 }
                        .map { game in
                            RetrieveGame(name: game.bg.name,
                                         quality: game.status,
                                         quantityAvailable: game.nb_sale,
                                         sellingPrice: game.price,
                                         idGameInventoryItemPublic: game.idGameInventoryItemPublic,
                                         source: "sale")
                        }
                case .failure(let error):
                    print("Error fetching storage data: \(error)")
                }
            }
        }
    }
    
    func confirmRetrieve(completion: @escaping (Result<Void, Error>) -> Void) {
        let depotItems = depotGames.filter { $0.quantityToTakeBack > 0 }
        let saleItems = saleGames.filter { $0.quantityToTakeBack > 0 }
        let allItems = depotItems + saleItems
        guard !allItems.isEmpty else {
            completion(.failure(NSError(domain: "No items selected", code: -1, userInfo: nil)))
            return
        }
        let retrieveItems = allItems.map { item in
            RetrieveItem(id_game_inventory_item_public: item.idGameInventoryItemPublic,
                         variation_stock: item.quantityToTakeBack,
                         source: item.source)
        }
        let request = RetrieveRequest(games: retrieveItems)
        retrieveService.submitRetrieve(request: request, completion: completion)
    }
    
    func cancelSelection() {
        depotGames = depotGames.map { game in
            var updated = game
            updated.quantityToTakeBack = 0
            return updated
        }
        saleGames = saleGames.map { game in
            var updated = game
            updated.quantityToTakeBack = 0
            return updated
        }
    }
}
