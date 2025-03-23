import Foundation

enum PurchaseServiceError: Error {
    case invalidResponse
}

class PurchaseService {
    func createPurchase(dto: CreatePurchaseDto, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // Create a custom JSONEncoder with the right date encoding strategy.
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            let dateString = dateFormatter.string(from: date)
            try container.encode(dateString)
        }
        
        guard let body = try? encoder.encode(dto) else {
            completion(.failure(PurchaseServiceError.invalidResponse))
            return
        }
        
        //print body for debugging
        print(String(data: body, encoding: .utf8) ?? "Invalid body")
        
        APIClient.shared.request(url: Endpoints.purchase, method: "POST", body: body) { (result: Result<EmptyResponse, Error>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
                //print error for debugging
                print(error)
            }
            
            //print result for debugging
            print(result)
        }
    }

    func fetchClientPurchases(clientPublicId: String, completion: @escaping (Result<[ClientPurchase], Error>) -> Void) {
        let urlString = "\(Endpoints.baseURL)/client/\(clientPublicId)/purchase"
        guard let url = URL(string: urlString) else { return }
        APIClient.shared.request(url: url, method: "GET", completion: completion)
    }
    
    func fetchPurchaseInstances(purchasePublicId: String, completion: @escaping (Result<[PurchaseGameItemInstance], Error>) -> Void) {
        let urlString = "\(Endpoints.baseURL)/purchase/\(purchasePublicId)/instances"
        guard let url = URL(string: urlString) else { return }
        APIClient.shared.request(url: url, method: "GET", completion: completion)
    }
}
