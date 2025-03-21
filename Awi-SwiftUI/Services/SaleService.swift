import Foundation

enum SaleServiceError: Error {
    case failedToSubmit
}

class SaleService {
    func submitSale(request: SaleRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = Endpoints.baseURL.appendingPathComponent("storage/to_sale")
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
        
        print("Submitting Sale Request ---")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data,
               let responseString = String(data: data, encoding: .utf8) {
                print("Raw Sale Response Data: \(responseString)")
            }
            completion(.success(()))
        }.resume()
    }
}
