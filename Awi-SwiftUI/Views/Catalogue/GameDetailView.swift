//
//  GameDetailView.swift
//  Awi-SwiftUI
//
//  Provides detailed information about a selected game.
//  Includes game description, inventory count, and pricing details.
//

import SwiftUI

struct GameDetailView: View {
    let game: Game
    // Optionally bind to a dedicated view model if further logic is needed.
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(game.title)
                    .font(.largeTitle)
                Text("Price: $\(game.price, specifier: "%.2f")")
                    .font(.title2)
                Text("Inventory: \(game.inventoryCount)")
                    .font(.subheadline)
                Text(game.description)
                    .font(.body)
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Game Details")
    }
}

struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a sample game for preview purposes.
        let sampleGame = Game(id: UUID(), title: "Sample Game", description: "A fun board game", price: 29.99, inventoryCount: 10)
        GameDetailView(game: sampleGame)
    }
}
