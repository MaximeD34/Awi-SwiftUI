//
//  SellerDetailViewModel.swift
//  Awi-SwiftUI
//
//  Manages the details and update logic for a specific seller.
//  Can also be used for adding a new seller.
//

import Foundation

class SellerDetailViewModel: ObservableObject {
    // Bindable properties for editing seller details.
    @Published var sellerName: String = ""
    
    private let sellerService = SellerService()
    
    func loadSellerDetails(for seller: Seller) {
        // Populate properties with seller data.
        sellerName = seller.name
    }
    
    func saveSeller(_ seller: Seller?) {
        // If seller is nil, add a new seller; otherwise, update existing seller.
        if let seller = seller {
            sellerService.updateSeller(sellerID: seller.id, name: sellerName) { result in
                // Handle update result
                print("Updated seller: \(result)")
            }
        } else {
            sellerService.addSeller(name: sellerName) { result in
                // Handle creation result
                print("Added seller: \(result)")
            }
        }
    }
}
