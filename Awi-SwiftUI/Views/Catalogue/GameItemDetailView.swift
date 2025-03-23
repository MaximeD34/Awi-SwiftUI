import SwiftUI

struct GameItemDetailView: View {
    let game: Game
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Game item info card
            VStack(alignment: .leading, spacing: 8) {
                // The boardgame's name is clickable. Use a NavigationLink to BoardGameDetailView.
                NavigationLink(destination: BoardGameDetailView(bgDetail: game.bgDetail)) {
                    Text(game.title)
                        .font(.headline)
                        .underline()
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
                
                // Status (condition)
                Text("Status: \(game.condition)")
                    .font(.subheadline)
                
                // Price
                Text("Price: $\(game.price, specifier: "%.2f")")
                    .font(.subheadline)
                
                // Seller name if available.
                if let sellerName = game.seller?.name {
                    Text("Seller: \(sellerName)")
                        .font(.subheadline)
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
            .padding(.horizontal)
            
            // Placeholder vertical scrollable list for serial numbers.
            Text("Serial Numbers")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(10...100, id: \.self) { number in
                        Text("Serial: \(number)")
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle("Game Item Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GameItemDetailView_Previews: PreviewProvider {
    static let sampleSeller = Seller(
        id: 1,
        idSellerPublic: "sample-public-id",
        name: "Houston Hobby",
        email: "houstonhobby@example.com",
        tel: "555-3456",
        billingAddress: "101 Game Pl, Houston"
    )
    
    static let sampleGame: Game = {
        var game = Game(
            id: 1,
            title: "Sample Game",
            description: "A fun board game",
            price: 29.99,
            inventoryCount: 10,
            condition: "New",
            publicId: "sample-public-id",
            yearPublished: nil,
            minPlayers: nil,
            maxPlayers: nil,
            minAge: nil,
            minPlaytime: nil,
            idEditorPublic: nil,
            editorName: nil
        )
        game.seller = sampleSeller
        return game
    }()
    
    static var previews: some View {
        NavigationView {
            GameItemDetailView(game: sampleGame)
        }
    }
}