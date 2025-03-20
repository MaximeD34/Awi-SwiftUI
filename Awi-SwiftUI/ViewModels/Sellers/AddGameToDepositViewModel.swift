import Foundation
import Combine

class AddGameToDepositViewModel: ObservableObject {
    @Published var selectedGameName: String = ""
    @Published var selectedQuality: String = "New"  // default quality
    @Published var quantity: Int = 0
    @Published var price: Double = 0.0
    @Published var discount: Int = 0
    @Published var depositItems: [DepositItem] = []
    @Published var availableGames: [BoardGame] = [] {
        didSet {
            // If the list is non-empty and no game is selected, set the default.
            if availableGames.count > 0 && selectedGameName.isEmpty {
                selectedGameName = availableGames[0].name
            }
        }
    }
    
    private let depositService = DepositService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchAvailableGames()
    }
    
    func fetchAvailableGames() {
        let url = Endpoints.baseURL.appendingPathComponent("boardgames/type")
        APIClient.shared.request(url: url) { (result: Result<[BoardGame], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let games):
                    self.availableGames = games
                case .failure(let error):
                    print("Error fetching available games: \(error)")
                }
            }
        }
    }
    
    func addToDeposit() {
        guard let selectedGame = availableGames.first(where: { $0.name == selectedGameName }) else { return }
        if let index = depositItems.firstIndex(where: { $0.name == selectedGameName && $0.quality == selectedQuality && $0.price == price }) {
            depositItems[index].quantity += quantity
        } else {
            let newItem = DepositItem(gameId: selectedGame.idBgPublic, name: selectedGameName, quality: selectedQuality, quantity: quantity, price: price)
            depositItems.append(newItem)
        }
        // Clear input fields after adding
        selectedGameName = availableGames.first?.name ?? ""
        selectedQuality = "New"
        quantity = 0
        price = 0.0
    }
    
    func clearDeposit() {
        depositItems.removeAll()
        discount = 0
    }
    
    var totalCharges: Double {
        depositItems.reduce(0) { $0 + ($1.price * Double($1.quantity) * 0.05) }
    }
    
    var discountedCharges: Double {
        totalCharges * (1 - Double(discount) / 100.0)
    }
    
    func confirmDeposit(selectedSeller: Seller, completion: @escaping (Result<Void, Error>) -> Void) {
        let depositGames = depositItems.map { item in
            DepositGame(stock: item.quantity, id_type_boardgame_public: item.gameId, status: item.quality, price: item.price)
        }
        let request = DepositRequest(discount: discount, id_seller_public: selectedSeller.idSellerPublic, games: depositGames)
        depositService.submitDeposit(request: request, completion: completion)
    }
}