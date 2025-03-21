import SwiftUI

struct AddGamesOnSaleView: View {
    let seller: Seller
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddGamesOnSaleViewModel()
    
    @State private var showResultAlert = false
    @State private var resultMessage = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(Array(viewModel.games.enumerated()), id: \.element.id) { index, game in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(game.name)
                                .font(.headline)
                            Text(game.quality)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("$\(game.sellingPrice, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Picker("", selection: $viewModel.games[index].quantityToSell) {
                            ForEach(0...game.quantityOnDepot, id: \.self) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 70, height: 40)
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(PlainListStyle())
            
            Button("Confirm") {
                viewModel.confirmSale(for: seller) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            resultMessage = "Sale confirmed successfully!"
                        case .failure(let error):
                            resultMessage = "Sale confirmation failed: \(error.localizedDescription)"
                        }
                        showResultAlert = true
                    }
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding()
        }
        .navigationTitle("Add Games on Sale")
        .onAppear {
            viewModel.fetchGames(for: seller)
        }
        .alert("Sale Status", isPresented: $showResultAlert) {
            Button("OK", role: .cancel) {
                if resultMessage.contains("successfully") {
                    dismiss()
                }
            }
        } message: {
            Text(resultMessage)
        }
    }
}

struct AddGamesOnSaleView_Previews: PreviewProvider {
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
            AddGamesOnSaleView(seller: sampleSeller)
        }
    }
}