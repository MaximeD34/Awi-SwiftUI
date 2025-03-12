//
//  CatalogueViewModel.swift
//  Awi-SwiftUI
//
//  Fetches and manages the list of games for the public catalogue.
//

import Foundation

class CatalogueViewModel: ObservableObject {
    @Published var games: [Game] = []
    
    private let gameService = GameService()
    
    func fetchGames() {
        gameService.fetchGames { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let games):
                    self?.games = games
                case .failure(let error):
                    print("Error fetching games: \(error)")
                }
            }
        }
    }
}
