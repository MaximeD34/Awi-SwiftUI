import SwiftUI

struct CatalogueRowView: View {
    let game: Game
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 4) {
                Text(game.title)
                    .font(.subheadline)
                    .bold()
                
                // Display the seller name if available.
                if let sellerName = game.seller?.name {
                    Text("Seller: \(sellerName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Condition and price appear on the third line.
                HStack {
                    Text(game.condition)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("$\(game.price, specifier: "%.2f")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            // Overlay the Stock text at a fixed offset.
            Text("Stock: \(game.inventoryCount)")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 22)  // Adjust this value until the text aligns with the seller line.
                .padding(.trailing, 4)
        }
        .padding(.vertical, 4)
    }
}

struct CatalogueRowView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a sample seller.
        let sampleSeller = Seller(
            id: 1,
            idSellerPublic: "sample-public-id",
            name: "Houston Hobby",
            email: "houstonhobby@example.com",
            tel: "555-3456",
            billingAddress: "101 Game Pl, Houston"
        )
        // Provide a sample game.
        var sampleGame = Game(
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
        // Attach the seller to the game.
        sampleGame.seller = sampleSeller
        
        return CatalogueRowView(game: sampleGame)
            .previewLayout(.sizeThatFits)
    }
}