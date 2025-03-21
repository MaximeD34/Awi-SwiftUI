import SwiftUI

struct CatalogueRowView: View {
    let game: Game
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(game.title)
                .font(.subheadline)
                .bold()
            
            HStack {
                Text(game.condition)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("$\(game.price, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Stock: \(game.inventoryCount)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

struct CatalogueRowView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a sample game for preview using the public initializer.
        let sampleGame = Game(
            id: 1,
            title: "Sample Game",
            description: "A fun board game",
            price: 29.99,
            inventoryCount: 10,
            condition: "New",
            publicId: "sample-public-id"
        )
        CatalogueRowView(game: sampleGame)
            .previewLayout(.sizeThatFits)
    }
}