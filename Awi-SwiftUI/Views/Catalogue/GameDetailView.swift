import SwiftUI

struct GameDetailView: View {
    let game: Game  // The game for which details are displayed

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(game.title)
                .font(.largeTitle)
            Text("Price: $\(game.price, specifier: "%.2f")")
                .font(.headline)
            Text("Condition: \(game.condition)")
                .font(.subheadline)
            Text("Available: \(game.inventoryCount)")
                .font(.subheadline)
            Text(game.description)
                .font(.body)
            Spacer()
        }
        .padding()
        .navigationTitle("Game Details")
    }
}

struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide all required parameters for the Game instance.
        let sampleGame = Game(
            id: 1,
            title: "Sample Game",
            description: "A fun board game for friends and family.",
            price: 29.99,
            inventoryCount: 10,
            condition: "New",
            publicId: "sample-public-id"
        )
        NavigationView {
            GameDetailView(game: sampleGame)
        }
    }
}