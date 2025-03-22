import Foundation

enum SellerServiceError: Error {
    case failedToFetch
    case failedToCreate
    case failedToUpdate
    case failedToDelete
}

class SellerService {
    func fetchSellers(completion: @escaping (Result<[Seller], Error>) -> Void) {
        let url = Endpoints.baseURL.appendingPathComponent("seller")
        APIClient.shared.request(url: url, method: "GET", completion: completion)
    }
    
    // New update method using PUT /seller/:id_seller_public.
    func updateSeller(dto: UpdateSellerDto, for seller: Seller, completion: @escaping (Result<Seller, Error>) -> Void) {
        let url = Endpoints.baseURL.appendingPathComponent("seller/\(seller.idSellerPublic)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
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
                completion(.failure(SellerServiceError.failedToUpdate))
                return
            }
            do {
                let updatedSeller = try JSONDecoder().decode(Seller.self, from: data)
                completion(.success(updatedSeller))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // New delete method using DELETE /seller/:id_seller_public.
    func deleteSeller(seller: Seller, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = Endpoints.baseURL.appendingPathComponent("seller/\(seller.idSellerPublic)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            // Optionally, inspect response status codes.
            completion(.success(()))
        }.resume()
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