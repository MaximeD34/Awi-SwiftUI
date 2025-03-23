import Foundation

class ClientService {
    func fetchClients(completion: @escaping (Result<[Client], Error>) -> Void) {
        let url = Endpoints.baseURL.appendingPathComponent("client")
        APIClient.shared.request(url: url, method: "GET", completion: completion)
    }
}
