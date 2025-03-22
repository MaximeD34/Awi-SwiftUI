//// filepath: /Users/etud/Documents/Awi-SwiftUI/Awi-SwiftUI/Views/Sellers/SellerCardView.swift
import SwiftUI

struct SellerCardView: View {
    let seller: Seller
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(seller.name)
                .font(.title2)
                .bold()
                .lineLimit(1)
            
            if let email = seller.email, !email.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "envelope")
                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            if let tel = seller.tel, !tel.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "phone")
                    Text(tel)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            if let billing = seller.billingAddress, !billing.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "house")
                    Text(billing)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding()
        .frame(height: 120)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
}

struct SellerCardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleSeller = Seller(
            id: 1,
            idSellerPublic: "sample-public-id",
            name: "Sample Seller",
            email: "seller@example.com",
            tel: "1234567890",
            billingAddress: "123 Address St."
        )
        SellerCardView(seller: sampleSeller)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
