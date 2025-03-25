import Foundation

enum GameItemInstanceServiceError: Error {
    case invalidSerial
    case failedToFetch
}

class GameItemInstanceService {
    func fetchGameItemInstance(serial: String, completion: @escaping (Result<GameItemInstance, Error>) -> Void) {
        let url = Endpoints.gameItemInstance(serial: serial)
        APIClient.shared.request(url: url) { (result: Result<GameItemInstance, Error>) in
            completion(result)
        }
    }
}

extension GameItemInstanceService {
    func fetchInstances(forPublicId publicId: String, completion: @escaping (Result<[GameItemInstanceExtended], Error>) -> Void) {
        let url = Endpoints.gameItemInstances(publicId: publicId)
        APIClient.shared.request(url: url) { (result: Result<[GameItemInstanceExtended], Error>) in
            completion(result)
        }
    }
}