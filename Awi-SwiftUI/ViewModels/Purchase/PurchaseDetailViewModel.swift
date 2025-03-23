import Foundation
import Combine

final class PurchaseDetailViewModel: ObservableObject {
    @Published var instances: [PurchaseGameItemInstance] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let purchaseService = PurchaseService()
    
    func fetchInstances(for purchasePublicId: String) {
        isLoading = true
        errorMessage = nil
        purchaseService.fetchPurchaseInstances(purchasePublicId: purchasePublicId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let instances):
                    self?.instances = instances
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
