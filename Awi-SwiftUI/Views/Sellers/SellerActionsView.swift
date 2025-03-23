import SwiftUI

struct SellerActionsView: View {
    let seller: Seller
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            // Seller Info Card with update/delete button on bottom-right.
            ZStack(alignment: .bottomTrailing) {
                // Seller info card with fixed dimensions.
                VStack(alignment: .leading, spacing: 8) {
                    Text(seller.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    if let email = seller.email, !email.isEmpty {
                        HStack {
                            Image(systemName: "envelope")
                            Text(email)
                                .lineLimit(1)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    if let tel = seller.tel, !tel.isEmpty {
                        HStack {
                            Image(systemName: "phone")
                            Text(tel)
                                .lineLimit(1)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    if let billing = seller.billingAddress, !billing.isEmpty {
                        HStack {
                            Image(systemName: "house")
                            Text(billing)
                                .lineLimit(1)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                }
                .padding()
                .frame(width: 300, height: 140)
                .clipped()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Update/Delete Button positioned at bottom-right.
                NavigationLink(destination: SellerUpdateView(seller: seller)
                                .environmentObject(coordinator)) {
                    Image(systemName: "pencil")
                        .padding(8)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .offset(x: -20, y: -5)
            }
            
            // Action buttons arranged as a 2x2 grid.
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    NavigationLink(destination: AddGameToDepositView(seller: seller)) {
                        VStack {
                            Image(systemName: "tray.and.arrow.down.fill")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Deposit")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .frame(width: 140, height: 100)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    NavigationLink(destination: AddGamesOnSaleView(seller: seller)) {
                        VStack {
                            Image(systemName: "tag.fill")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Sale")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .frame(width: 140, height: 100)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                }
                HStack(spacing: 16) {
                    NavigationLink(destination: TakeBackGameView(seller: seller)) {
                        VStack {
                            Image(systemName: "arrow.uturn.left.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Take back")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .frame(width: 140, height: 100)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    // New 4th Button for Seller Statistics.
                    NavigationLink(destination: SellerStatisticsView(seller: seller)) {
                        VStack {
                            Image(systemName: "chart.bar")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Stats")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .frame(width: 140, height: 100)
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
    }
}

struct SellerActionsView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleSeller = Seller(
            id: 1,
            idSellerPublic: "sample-public-id",
            name: "Sample Seller with a very very long name to test fixed sizing",
            email: "seller@example.com",
            tel: "1234567890",
            billingAddress: "123 Address St. This is a very long address example to test fixed sizing"
        )
        NavigationView {
            SellerActionsView(seller: sampleSeller)
                .environmentObject(NavigationCoordinator())
        }
    }
}