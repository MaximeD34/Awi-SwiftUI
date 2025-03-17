import Foundation

enum GameItemInstanceServiceError: Error {
    case invalidSerial
    case failedToFetch
}

class GameItemInstanceService {
    func fetchGameItemInstance(serial: String, completion: @escaping (Result<GameItemInstance, Error>) -> Void) {
        let url = Endpoints.gameItemInstance(serial: serial)
        // Use your APIClient here – assuming it supports Decodable generic calls.
        APIClient.shared.request(url: url) { (result: Result<GameItemInstance, Error>) in
            completion(result)
        }
    }
}