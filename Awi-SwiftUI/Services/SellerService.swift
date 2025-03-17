import Foundation

enum SellerServiceError: Error {
    case failedToFetch
}

class SellerService {
    func fetchSellers(completion: @escaping (Result<[Seller], Error>) -> Void) {
        // Simulate fetching sellers. Replace with an API call if needed.
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let sampleSellers: [Seller] = [] // Now explicitly an empty [Seller] array
            completion(.success(sampleSellers))
        }
    }
    
    func updateSeller(sellerID: Int, name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Implement update logic here.
        // For instance, perform a network request using sellerID and name.
        completion(.success(()))
    }
    
    func addSeller(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Implement creation logic here.
        completion(.success(()))
    }
}