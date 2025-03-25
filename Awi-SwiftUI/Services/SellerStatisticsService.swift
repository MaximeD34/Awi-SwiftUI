import Foundation

enum SellerStatisticsServiceError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Error)
}

class SellerStatisticsService {
    func fetchStats(for seller: Seller, completion: @escaping (Result<SellerStats, Error>) -> Void) {
        guard let url = URL(string: "\(Endpoints.baseURL)/seller/\(seller.idSellerPublic)/stat") else {
            completion(.failure(SellerStatisticsServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer YOUR_VALID_TOKEN", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(SellerStatisticsServiceError.serverError(error)))
                return
            }
            guard let data = data else {
                completion(.failure(SellerStatisticsServiceError.noData))
                return
            }
            do {
                let stats = try JSONDecoder().decode(SellerStats.self, from: data)
                completion(.success(stats))
            } catch {
                completion(.failure(SellerStatisticsServiceError.decodingError(error)))
            }
        }.resume()
    }
}
