import Foundation

final class SellerDetailViewModel: ObservableObject {
    @Published var sellerName: String = ""
    
    private let sellerService = SellerService()
    
    func loadSellerDetails(for seller: Seller) {
        // Populate the property with seller data.
        sellerName = seller.name
    }
    
    func saveSeller(_ seller: Seller?) {
        if let seller = seller {
            // Update existing seller.
            sellerService.updateSeller(sellerID: seller.id, name: sellerName) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        print("Seller updated successfully")
                    case .failure(let error):
                        print("Error updating seller: \(error)")
                    }
                }
            }
        } else {
            // Create a new seller.
            sellerService.addSeller(name: sellerName) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        print("Seller created successfully")
                    case .failure(let error):
                        print("Error creating seller: \(error)")
                    }
                }
            }
        }
    }
}