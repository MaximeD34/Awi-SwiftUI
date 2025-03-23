import Foundation

enum SellerServiceError: Error, LocalizedError {
    case failedToFetch
    case failedToCreate
    case failedToUpdate
    case failedToDelete(String)
    
    var errorDescription: String? {
        switch self {
        case .failedToDelete(let message):
            return message
        default:
            return "An unknown error occurred."
        }
    }
}

// Model used when the backend returns an error response.
struct ErrorResponse: Codable {
    let message: String
    let error: String
    let statusCode: Int
}

// New model to decode the response from the createSeller endpoint.
struct CreatedSellerResponse: Codable {
    let seller: Seller
}

struct EmptyResponse: Decodable { }

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
    
    // Updated delete method using URLSession (instead of APIClient) so we can check error responses.
    func deleteSeller(seller: Seller, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = Endpoints.baseURL.appendingPathComponent("seller/\(seller.idSellerPublic)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = TokenManager.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(SellerServiceError.failedToDelete("Invalid server response.")))
                return
            }
            if httpResponse.statusCode >= 400 {
                // Attempt to decode the error response.
                if let data = data,
                   let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    completion(.failure(SellerServiceError.failedToDelete(errorResponse.message)))
                } else {
                    completion(.failure(SellerServiceError.failedToDelete("Unknown error occurred.")))
                }
            } else {
                completion(.success(()))
            }
        }.resume()
    }
    
    // Updated createSeller method.
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
                // First, attempt decoding assuming the response is wrapped in a "seller" key.
                let createdResponse = try JSONDecoder().decode(CreatedSellerResponse.self, from: data)
                completion(.success(createdResponse.seller))
            } catch {
                // If that fails, try decoding Seller directly.
                do {
                    let seller = try JSONDecoder().decode(Seller.self, from: data)
                    completion(.success(seller))
                } catch {
                    // For debugging: print the raw response.
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw seller create response: \(jsonString)")
                    }
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}