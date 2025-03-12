//
//  GameService.swift
//  Awi-SwiftUI
//
//  Provides CRUD operations for games.
//  Interacts with APIClient to fetch, add, update, or delete games.
//

import Foundation

enum GameServiceError: Error {
    case failedToFetch
}

class GameService {
    func fetchGames(completion: @escaping (Result<[Game], Error>) -> Void) {
        APIClient.shared.request(url: Endpoints.games) { (result: Result<[Game], Error>) in
            completion(result)
        }
    }
    
    // Add methods for add/update/delete if needed.
}
