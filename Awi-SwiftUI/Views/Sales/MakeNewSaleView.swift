import SwiftUI

struct MakeNewSaleView: View {
    @StateObject private var viewModel = MakeNewSaleViewModel()
    @State private var showConfirmAlert = false       // Controls the confirmation prompt
    @State private var showResultAlert = false        // Controls the result message alert
    @State private var resultMessage = ""             // Message for the result alert
    
    var body: some View {
        VStack {
            // Search bar
            HStack {
                TextField("Enter serial number", text: $viewModel.serialNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        viewModel.searchGameItem()
                    }
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .padding()
            
            // Error display
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            // List of fetched game items
            List {
                ForEach(viewModel.gameItemInstances) { item in
                    ZStack {
                        // Use a conditional background to highlight duplicates.
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.gameInventoryItem.bg.name)
                                    .font(.headline)
                                Text(item.gameInventoryItem.status)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Seller: \(item.gameInventoryItem.seller.name)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("$\(item.gameInventoryItem.price, specifier: "%.2f")")
                        }
                        .padding(.vertical, 4)
                    }
                    .background(
                        viewModel.highlightedItemID == item.id ?
                            Color.yellow.opacity(0.5) : Color.clear
                    )
                    .animation(.easeInOut, value: viewModel.highlightedItemID)
                }
                .onDelete { offsets in
                    viewModel.removeItems(at: offsets)
                }
            }
            
            // Total price display
            HStack {
                Spacer()
                Text("Total: $\(viewModel.totalPrice, specifier: "%.2f")")
                    .font(.headline)
                    .padding()
            }
            
            // Cancel and Confirm buttons
            HStack {
                Button("Cancel") {
                    viewModel.cancelSale()
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Spacer()
                
                Button("Confirm") {
                    showConfirmAlert = true
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(.horizontal)
        }
        // Confirmation alert (classic iOS modal)
        .alert("Confirm Sale", isPresented: $showConfirmAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm") {
                viewModel.confirmSale { result in
                    switch result {
                    case .success:
                        resultMessage = "Sale confirmed successfully!"
                    case .failure(let error):
                        resultMessage = "Sale confirmation failed: \(error.localizedDescription)"
                    }
                    showResultAlert = true
                }
            }
        } message: {
            Text("Are you sure you want to validate this sale?")
        }
        // Result alert after API call
        .alert("Result", isPresented: $showResultAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(resultMessage)
        }
    }
}

struct MakeNewSaleView_Previews: PreviewProvider {
    static var previews: some View {
        MakeNewSaleView()
    }
}