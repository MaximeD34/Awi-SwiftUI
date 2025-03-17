//
//  SellerDetailView.swift
//  Awi-SwiftUI
//
//  Displays detailed information about a specific seller,
//  including their activity history and associated transactions.
//

import SwiftUI

struct SellerDetailView: View {
    let seller: Seller
    @StateObject private var viewModel = SellerDetailViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(seller.name)
                .font(.largeTitle)
            // Display additional seller details here.
        
            Spacer()
        }
        .padding()
        .navigationTitle("Seller Details")
        .onAppear {
            viewModel.loadSellerDetails(for: seller)
        }
    }
}

