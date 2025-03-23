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

// New method to fetch multiple instances by game inventory public ID.
extension GameItemInstanceService {
    func fetchInstances(forPublicId publicId: String, completion: @escaping (Result<[GameItemInstanceExtended], Error>) -> Void) {
        let url = Endpoints.gameItemInstances(publicId: publicId)
        // This new method uses your APIClient to decode an array of GameItemInstanceExtended
        APIClient.shared.request(url: url) { (result: Result<[GameItemInstanceExtended], Error>) in
            completion(result)
        }
    }
}