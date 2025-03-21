import SwiftUI

struct SellerActionsView: View {
    let seller: Seller
    
    var body: some View {
        VStack(spacing: 20) {
            Text(seller.name)
                .font(.title)
                .padding()
            
            NavigationLink(destination: AddGameToDepositView(seller: seller, dismissAction: {})) {
                Text("Add a Game to Deposit")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            NavigationLink(destination: AddGamesOnSaleView(seller: seller, dismissAction: {})) {
                Text("Put a Game on Sale")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            NavigationLink(destination: TakeBackGameView(seller: seller, dismissAction: {})) {
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
        // Removed the custom .navigationTitle("Seller Actions")
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