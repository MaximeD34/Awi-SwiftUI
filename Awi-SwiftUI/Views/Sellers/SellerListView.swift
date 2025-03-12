//
//  SellerListView.swift
//  Awi-SwiftUI
//
//  Displays a list of sellers managed by the current Manager.
//  Allows navigation to seller details or editing views.
//

import SwiftUI

struct SellerListView: View {
    @StateObject private var viewModel = SellerListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.sellers) { seller in
                NavigationLink(destination: SellerDetailView(seller: seller)) {
                    Text(seller.name)
                }
            }
            .navigationTitle("Sellers")
            .onAppear {
                viewModel.fetchSellers()
            }
        }
    }
}

struct SellerListView_Previews: PreviewProvider {
    static var previews: some View {
        SellerListView()
    }
}
