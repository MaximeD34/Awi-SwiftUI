import Foundation

enum DepositServiceError: Error {
    case failedToSubmit
}

class DepositService {
    func submitDeposit(request: DepositRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = Endpoints.baseURL.appendingPathComponent("deposit")
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
        print("DOING THE REQUEST ---")
        URLSession.shared.dataTask(with: urlRequest) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            // For simplicity, assume success if no error.
            completion(.success(()))
        }.resume()
    }
}
