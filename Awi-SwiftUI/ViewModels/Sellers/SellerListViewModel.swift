//
//  SellerListViewModel.swift
//  Awi-SwiftUI
//
//  Fetches and manages the list of sellers for the current Manager.
//

import Foundation

class SellerListViewModel: ObservableObject {
    @Published var sellers: [Seller] = []
    
    private let sellerService = SellerService()
    
    func fetchSellers() {
        sellerService.fetchSellers { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sellers):
                    self?.sellers = sellers
                case .failure(let error):
                    print("Error fetching sellers: \(error)")
                }
            }
        }
    }
}
