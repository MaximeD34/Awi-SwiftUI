import Foundation
import Combine

enum SellerAction {
    case addDeposit, putOnSale, takeBack
}

class SellerListViewModel: ObservableObject {
    @Published var sellers: [Seller] = []
    @Published var filteredSellers: [Seller] = []
    
    @Published var searchName: String = ""
    // Removed searchEmail and searchTel

    // Pagination properties (client-side)
    @Published var currentPage: Int = 1
    @Published var pageSize: Int = 5
    var totalPages: Int {
        let count = filteredSellers.count
        return count == 0 ? 1 : Int(ceil(Double(count) / Double(pageSize)))
    }
    
    @Published var selectedSeller: Seller? = nil
    
    private let sellerService = SellerService()
    
    func fetchSellers() {
        sellerService.fetchSellers { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sellers):
                    self?.sellers = sellers
                    self?.filteredSellers = sellers
                    self?.currentPage = 1
                case .failure(let error):
                    print("Error fetching sellers: \(error)")
                }
            }
        }
    }
    
    func filterSellers() {
        if searchName.isEmpty {
            filteredSellers = sellers
        } else {
            filteredSellers = sellers.filter { seller in
                seller.name.lowercased().contains(searchName.lowercased())
            }
        }
        currentPage = 1
    }
    
    func sellersForCurrentPage() -> [Seller] {
        let startIndex = (currentPage - 1) * pageSize
        let endIndex = min(startIndex + pageSize, filteredSellers.count)
        if startIndex < endIndex {
            return Array(filteredSellers[startIndex..<endIndex])
        }
        return []
    }
    
    func nextPage() {
        if currentPage < totalPages {
            currentPage += 1
        }
    }
    
    func previousPage() {
        if currentPage > 1 {
            currentPage -= 1
        }
    }
    
    func selectSeller(_ seller: Seller) {
        if selectedSeller?.id == seller.id {
            selectedSeller = nil
        } else {
            selectedSeller = seller
        }
    }
}