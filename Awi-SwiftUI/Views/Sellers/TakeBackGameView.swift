import SwiftUI

struct TakeBackGameView: View {
    let seller: Seller
    var dismissAction: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button(action: dismissAction) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .padding()
                Spacer()
            }
            Spacer()
            Text("Take Back a Game")
                .font(.title)
                .padding()
            Text("Placeholder for seller: \(seller.name)")
            Spacer()
        }
    }
}

struct TakeBackGameView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleSeller = Seller(
            id: 1,
            idSellerPublic: "sample-public-id",
            name: "Sample Seller",
            email: "seller@example.com",
            tel: "1234567890",
            billingAddress: "123 Address St."
        )
        TakeBackGameView(seller: sampleSeller, dismissAction: {})
    }
}
