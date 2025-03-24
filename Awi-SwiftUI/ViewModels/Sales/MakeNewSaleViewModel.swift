import Foundation
import Combine
import SwiftUI

class MakeNewSaleViewModel: ObservableObject {
    @Published var serialNumber: String = ""
    @Published var gameItemInstances: [GameItemInstance] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var highlightedItemID: Int?
    
    private let gameItemInstanceService = GameItemInstanceService()
    private let purchaseService = PurchaseService()
    
    func searchGameItem() {
        guard !serialNumber.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        gameItemInstanceService.fetchGameItemInstance(serial: serialNumber) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let item):
                    if let duplicate = self?.gameItemInstances.first(where: { $0.id == item.id }) {
                        self?.highlightedItemID = duplicate.id
                        self?.serialNumber = ""
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation { self?.highlightedItemID = nil }
                        }
                    } else {
                        self?.gameItemInstances.append(item)
                        self?.serialNumber = ""
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func removeItem(instance: GameItemInstance) {
        gameItemInstances.removeAll { $0.id == instance.id }
    }
    
    func removeItems(at offsets: IndexSet) {
        gameItemInstances.remove(atOffsets: offsets)
    }
    
    var totalPrice: Double {
        gameItemInstances.reduce(0) { $0 + $1.gameInventoryItem.price }
    }
    
    func cancelSale() {
        serialNumber = ""
        gameItemInstances.removeAll()
        errorMessage = nil
        highlightedItemID = nil
    }
    
    func confirmSale(clientPublicId: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        let selectedClientId = clientPublicId ?? "default-client-public-id"
        let dto = CreatePurchaseDto(
            date: Date(),
            game_item_instance_ids: gameItemInstances.map { $0.idGameItemInstancePublic },
            id_client_public: selectedClientId
        )
        purchaseService.createPurchase(dto: dto) { result in
            DispatchQueue.main.async {
                if case .success = result {
                    self.cancelSale()
                }
                completion(result)
            }
        }
    }
}
