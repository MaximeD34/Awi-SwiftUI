import Foundation

enum RetrieveServiceError: Error {
    case failedToSubmit
}

class RetrieveService {
    func submitRetrieve(request: RetrieveRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = Endpoints.baseURL.appendingPathComponent("storage/take_back")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(request)
            urlRequest.httpBody = data
        } catch {
            completion(.failure(error))
            return
        }
        
        print("Submitting Retrieve Request ---")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data,
               let responseString = String(data: data, encoding: .utf8) {
                print("Raw Retrieve Response Data: \(responseString)")
            }
            completion(.success(()))
        }.resume()
    }
}

struct RetrieveRequest: Codable {
    let games: [RetrieveItem]
}

struct RetrieveItem: Codable {
    let id_game_inventory_item_public: String
    let variation_stock: Int
    let source: String
}
