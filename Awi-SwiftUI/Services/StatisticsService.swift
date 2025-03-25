import Foundation

enum StatisticsServiceError: Error {
    case failed(String)
}

class StatisticsService {
    func fetchStatistics(sessionId: Int, completion: @escaping (Result<Statistics, Error>) -> Void) {
        let urlString = "\(Endpoints.baseURL)/company/stat"
        guard let url = URL(string: urlString) else {
            completion(.failure(StatisticsServiceError.failed("Invalid URL")))
            return
        }
        let request = URLRequest(url: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(StatisticsServiceError.failed("No data received")))
                return
            }
            do {
                let stats = try decoder.decode(Statistics.self, from: data)
                completion(.success(stats))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func refreshStatistics(completion: @escaping (Result<Void, Error>) -> Void) {
        let urlString = "\(Endpoints.baseURL)/company/stat/refresh"
        guard let url = URL(string: urlString) else {
            completion(.failure(StatisticsServiceError.failed("Invalid URL")))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // or GET if appropriate
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }.resume()
    }
}
