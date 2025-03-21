import SwiftUI

struct AddGamesOnSaleView: View {
    let seller: Seller
    var dismissAction: () -> Void
    @StateObject private var viewModel = AddGamesOnSaleViewModel()
    
    @State private var showResultAlert = false
    @State private var resultMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // Enumerate over the games array so we can bind to each item's quantityToSell.
                    ForEach(Array(viewModel.games.enumerated()), id: \.element.id) { index, game in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(game.name)
                                    .font(.headline)
                                Text(game.quality)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            // A menu-style picker showing a scrollable list of numbers.
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
            // .navigationBarItems(leading:
            //     Button(action: dismissAction) {
            //         HStack {
            //             Image(systemName: "chevron.left")
            //             Text("Back")
            //         }
            //     }
            // )
            .onAppear {
                viewModel.fetchGames(for: seller)
            }
            .alert("Sale Status", isPresented: $showResultAlert) {
                Button("OK", role: .cancel) {
                    if resultMessage.contains("successfully") {
                        dismissAction()
                    }
                }
            } message: {
                Text(resultMessage)
            }
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
        AddGamesOnSaleView(seller: sampleSeller, dismissAction: {})
    }
}