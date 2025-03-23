import Foundation

class APIClient {
    static let shared = APIClient()
    private init() { }
    
    func request<T: Decodable>(
        url: URL,
        method: String = "GET",
        body: Data? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Add JWT token if available
        if let token = TokenManager.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "APIClient", code: -1, userInfo: nil)))
                return
            }
            
            // Debug print the raw response as string
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw Response Data: \(jsonString)")
            }
            else{
                print("Raw Response Data: <empty>")
            }
            
            let decoder = JSONDecoder()
            // Custom date decoding strategy to support fractional seconds.
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            decoder.dateDecodingStrategy = .custom({ decoder in
                let container = try decoder.singleValueContainer()
                let dateStr = try container.decode(String.self)
                if let date = isoFormatter.date(from: dateStr) {
                    return date
                }
                throw DecodingError.dataCorruptedError(in: container,
                    debugDescription: "Cannot decode date string \(dateStr)")
            })
            
            do {
                let decoded = try decoder.decode(T.self, from: data)
                completion(.success(decoded))
                
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getCookie(named name: String) -> String? {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                if cookie.name == name {
                    return cookie.value
                }
            }
        }
        return nil
    }
}
