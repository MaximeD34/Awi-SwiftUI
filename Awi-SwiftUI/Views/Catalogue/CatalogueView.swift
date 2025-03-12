//
//  CatalogueView.swift
//  Awi-SwiftUI
//
//  Displays the public catalogue of available games for sale.
//  Lists each game with its title and price.
//

import SwiftUI

struct CatalogueView: View {
    @StateObject private var viewModel = CatalogueViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.games) { game in
                NavigationLink(destination: GameDetailView(game: game)) {
                    VStack(alignment: .leading) {
                        Text(game.title)
                            .font(.headline)
                        Text("$\(game.price, specifier: "%.2f")")
                            .font(.subheadline)
                    }
                }
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
