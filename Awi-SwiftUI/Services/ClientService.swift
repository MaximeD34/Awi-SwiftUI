import Foundation

class ClientService {
    func fetchClients(completion: @escaping (Result<[Client], Error>) -> Void) {
        let url = Endpoints.baseURL.appendingPathComponent("client")
        APIClient.shared.request(url: url, method: "GET", completion: completion)
    }

    func createClient(dto: CreateClientDto, completion: @escaping (Result<Client, Error>) -> Void) {
        let urlString = "\(Endpoints.baseURL)/client"
        guard let url = URL(string: urlString) else {
            return
        }
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(dto)
            APIClient.shared.request(url: url, method: "POST", body: data, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
}