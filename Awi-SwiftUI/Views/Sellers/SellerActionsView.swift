import SwiftUI

struct SellerActionsView: View {
    let seller: Seller
    
    var body: some View {
        VStack(spacing: 20) {
            // Seller Info Card
            VStack(alignment: .leading, spacing: 8) {
                Text(seller.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                if let email = seller.email, !email.isEmpty {
                    HStack {
                        Image(systemName: "envelope")
                        Text(email)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                
                if let tel = seller.tel, !tel.isEmpty {
                    HStack {
                        Image(systemName: "phone")
                        Text(tel)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                
                if let billing = seller.billingAddress, !billing.isEmpty {
                    HStack {
                        Image(systemName: "house")
                        Text(billing)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Action buttons
            NavigationLink(destination: AddGameToDepositView(seller: seller)) {
                Text("Add a Game to Deposit")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            NavigationLink(destination: AddGamesOnSaleView(seller: seller)) {
                Text("Put a Game on Sale")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            NavigationLink(destination: TakeBackGameView(seller: seller)) {
                Text("Take Back a Game")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
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
            name: "Sample Seller",
            email: "seller@example.com",
            tel: "1234567890",
            billingAddress: "123 Address St."
        )
        NavigationView {
            SellerActionsView(seller: sampleSeller)
        }
    }
}