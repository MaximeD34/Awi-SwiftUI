import Foundation

enum SellerServiceError: Error {
    case failedToFetch
    case failedToCreate
}

class SellerService {
    func fetchSellers(completion: @escaping (Result<[Seller], Error>) -> Void) {
        let url = Endpoints.baseURL.appendingPathComponent("seller")
        APIClient.shared.request(url: url, method: "GET", completion: completion)
    }
    
    func updateSeller(sellerID: Int, name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Update logic here. For now, we simulate success.
        completion(.success(()))
    }
    
    func createSeller(dto: CreateSellerDto, completion: @escaping (Result<Seller, Error>) -> Void) {
        let url = Endpoints.baseURL.appendingPathComponent("seller")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let data = try JSONEncoder().encode(dto)
            request.httpBody = data
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(SellerServiceError.failedToCreate))
                return
            }
            do {
                let seller = try JSONDecoder().decode(Seller.self, from: data)
                completion(.success(seller))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}