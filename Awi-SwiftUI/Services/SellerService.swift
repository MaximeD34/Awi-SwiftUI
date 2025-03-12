//
//  SellerService.swift
//  Awi-SwiftUI
//
//  Handles seller-related operations such as fetching seller lists,
//  updating seller details, or adding new sellers.
//

import Foundation

enum SellerServiceError: Error {
    case failedToFetch
}

class SellerService {
    func fetchSellers(completion: @escaping (Result<[Seller], Error>) -> Void) {
        // Simulate fetching sellers. Replace with an API call if needed.
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let sampleSellers = [
                Seller(id: UUID(), name: "Seller One", assignedManagerID: UUID()),
                Seller(id: UUID(), name: "Seller Two", assignedManagerID: UUID())
            ]
            completion(.success(sampleSellers))
        }
    }
    
    func updateSeller(sellerID: UUID, name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Simulate an update operation.
        completion(.success(()))
    }
    
    func addSeller(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Simulate an add operation.
        completion(.success(()))
    }
}
