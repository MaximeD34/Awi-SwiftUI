import SwiftUI

struct CatalogueRowView: View {
    let game: Game
    
    var body: some View {
        HStack {
            Text(game.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("$\(game.price, specifier: "%.2f")")
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("\(game.condition)")
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            Text("\(game.inventoryCount)")
                .frame(maxWidth: .infinity, alignment: .trailing)
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