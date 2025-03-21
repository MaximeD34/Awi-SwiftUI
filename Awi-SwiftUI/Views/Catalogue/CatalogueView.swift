import SwiftUI

struct CatalogueView: View {
    @StateObject private var viewModel = CatalogueViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.games) { game in
                    NavigationLink(destination: BoardGameDetailView(bgDetail: game.bgDetail)) {
                        CatalogueRowView(game: game)
                    }
                }
                .listStyle(PlainListStyle())
                
                // Pagination controls or other catalogue features...
            }
            .navigationTitle("Catalogue")
            .onAppear {
                viewModel.fetchGames()
            }
        }
    }
}

struct CatalogueView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogueView()
    }
}