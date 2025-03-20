import Foundation

enum GameServiceError: Error {
    case failedToFetch
}

class GameService {
    func fetchGames(page: Int, pageSize: Int, completion: @escaping (Result<CatalogueResponse, Error>) -> Void) {
        // Use the catalogue endpoint "game-inventory-item"
        let url = Endpoints.baseURL.appendingPathComponent("game-inventory-item")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "page_size", value: "\(pageSize)")
        ]
        guard let urlWithQuery = components.url else {
            completion(.failure(GameServiceError.failedToFetch))
            return
        }
        
        // Decode CatalogueResponse instead of a bare array.
        APIClient.shared.request(url: urlWithQuery) { (result: Result<CatalogueResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}