import SwiftUI

struct CatalogueView: View {
    @StateObject private var viewModel = CatalogueViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.games) { game in
                    // Change destination from BoardGameDetailView to GameItemDetailView.
                    NavigationLink(destination: GameItemDetailView(game: game)) {
                        CatalogueRowView(game: game)
                    }
                }
                .listStyle(PlainListStyle())
                
                // Always display pagination controls, even with one page.
                HStack {
                    Button(action: {
                        viewModel.previousPage()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(viewModel.currentPage == 1 ? .gray : .blue)
                    }
                    
                    // Show the page text even for one page.
                    Text("Page \(viewModel.currentPage) of \(viewModel.totalPages)")
                        .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        viewModel.nextPage()
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(viewModel.currentPage == viewModel.totalPages ? .gray : .blue)
                    }
                }
                .padding()
            }
            .navigationTitle("Catalogue")
            .onAppear {
                viewModel.fetchGames()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Force single-column style on iPad.
    }
}

struct CatalogueView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogueView()
    }
}