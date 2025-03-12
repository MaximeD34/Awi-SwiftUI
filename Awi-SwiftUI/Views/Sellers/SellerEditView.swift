//
//  SellerEditView.swift
//  Awi-SwiftUI
//
//  Provides a form to edit or add new seller details.
//  Binds to a SellerDetailViewModel for updating seller data.
//

import SwiftUI

struct SellerEditView: View {
    @StateObject private var viewModel = SellerDetailViewModel()
    var seller: Seller? // If nil, it can be used to add a new seller
    
    var body: some View {
        Form {
            Section(header: Text("Seller Information")) {
                TextField("Name", text: $viewModel.sellerName)
                // Add additional fields as needed.
            }
            Button("Save") {
                viewModel.saveSeller(seller)
            }
        }
        .navigationTitle(seller == nil ? "Add Seller" : "Edit Seller")
    }
}

struct SellerEditView_Previews: PreviewProvider {
    static var previews: some View {
        // For preview, we pass nil to simulate adding a new seller.
        SellerEditView(seller: nil)
    }
}
