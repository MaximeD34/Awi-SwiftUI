import Foundation

enum SellerServiceError: Error {
    case failedToFetch
}

class SellerService {
    func fetchSellers(completion: @escaping (Result<[Seller], Error>) -> Void) {
        let url = Endpoints.baseURL.appendingPathComponent("seller")
        APIClient.shared.request(url: url, method: "GET", completion: completion)
    }
    
    func updateSeller(sellerID: Int, name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Implement update logic here.
        // For instance, perform a network request using sellerID and name.
        // For now, we'll simulate a success:
        completion(.success(()))
    }
    
    func addSeller(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Implement creation logic here.
        // For now, we'll simulate a success:
        completion(.success(()))
    }
}