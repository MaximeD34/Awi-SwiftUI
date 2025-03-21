import SwiftUI

struct AddGameToDepositView: View {
    let seller: Seller
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddGameToDepositViewModel()
    
    @State private var showResultAlert = false
    @State private var resultMessage = ""
    
    // Formatter for quantity (no grouping)
    private var quantityFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }
    
    // Formatter for price
    private var priceFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Create a Deposit")) {
                    Picker("Game Name", selection: $viewModel.selectedGameName) {
                        ForEach(viewModel.availableGames, id: \.idBgPublic) { game in
                            Text(game.name).tag(game.name)
                        }
                    }
                    
                    Picker("Quality", selection: $viewModel.selectedQuality) {
                        ForEach(["New", "Used"], id: \.self) { quality in
                            Text(quality).tag(quality)
                        }
                    }
                    
                    HStack {
                        Text("Quantity")
                        Spacer()
                        TextField("Quantity", value: $viewModel.quantity, formatter: quantityFormatter)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Price")
                        Spacer()
                        TextField("Price", value: $viewModel.price, formatter: priceFormatter)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Button("Add to Deposit") {
                        viewModel.addToDeposit()
                        viewModel.confirmDeposit(selectedSeller: seller) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success:
                                    resultMessage = "Deposit confirmed successfully!"
                                case .failure(let error):
                                    resultMessage = "Deposit confirmation failed: \(error.localizedDescription)"
                                }
                                showResultAlert = true
                            }
                        }
                    }
                    .disabled(viewModel.selectedGameName.isEmpty ||
                              viewModel.selectedQuality.isEmpty ||
                              viewModel.quantity < 1 ||
                              viewModel.price <= 0)
                }
            }
            .navigationBarTitle("Add a Game to Deposit", displayMode: .inline)
            .alert("Deposit Status", isPresented: $showResultAlert) {
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
}

struct AddGameToDepositView_Previews: PreviewProvider {
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
            AddGameToDepositView(seller: sampleSeller)
        }
    }
}