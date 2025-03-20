import SwiftUI

struct CatalogueView: View {
    @StateObject private var viewModel = CatalogueViewModel()
    
    // NumberFormatter for pageSize TextField input.
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.games.isEmpty {
                    LoadingView()
                } else {
                    List(viewModel.games) { game in
                        CatalogueRowView(game: game)
                    }
                }
                
                // Pagination controls
                HStack {
                    Button(action: {
                        viewModel.previousPage()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(viewModel.currentPage == 1 ? .gray : .blue)
                    }
                    .disabled(viewModel.currentPage == 1)
                    
                    Text("Page \(viewModel.currentPage)")
                        .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        viewModel.nextPage()
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(viewModel.currentPage == viewModel.totalPages ? .gray : .blue)
                    }
                    .disabled(viewModel.currentPage == viewModel.totalPages)
                    
                    Spacer()
                    
                    Text("Page Size:")
                    
                    TextField("Page Size", value: $viewModel.pageSize, formatter: numberFormatter)
                        .frame(width: 50)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Set") {
                        // Reset to page 1 and refresh.
                        viewModel.currentPage = 1
                        viewModel.fetchGames()
                    }
                }
                .padding()
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