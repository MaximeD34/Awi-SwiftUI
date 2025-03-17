import Foundation
import Combine
import SwiftUI

class MakeNewSaleViewModel: ObservableObject {
    @Published var serialNumber: String = ""
    @Published var gameItemInstances: [GameItemInstance] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var highlightedItemID: Int?    // NEW property

    private let gameItemInstanceService = GameItemInstanceService()
    private let purchaseService = PurchaseService()   // NEW purchase service instance
    
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
                        // Already exists: highlight the duplicate and clear the serialNumber field.
                        self?.highlightedItemID = duplicate.id
                        self?.serialNumber = ""
                        // Reset the highlight after 1 second
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                self?.highlightedItemID = nil
                            }
                        }
                    } else {
                        self?.gameItemInstances.append(item)
                        self?.serialNumber = ""  // clear input upon success
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
    
    // Cancel sale: clears the sale list and serial number field.
    func cancelSale() {
        serialNumber = ""
        gameItemInstances.removeAll()
        errorMessage = nil
        highlightedItemID = nil
    }
    
    // Confirm sale: build DTO and call the POST /purchase endpoint.
    func confirmSale(completion: @escaping (Result<Void, Error>) -> Void) {
        // Create DTO from current sale. Use each instance’s public ID.
        let dto = CreatePurchaseDto(
            date: Date(),
            game_item_instance_ids: gameItemInstances.map { $0.idGameItemInstancePublic }
        )
        
        purchaseService.createPurchase(dto: dto) { result in
            DispatchQueue.main.async {
                if case .success = result {
                    self.cancelSale()  // clear sale on success
                }
                completion(result)
            }
        }
    }
}
