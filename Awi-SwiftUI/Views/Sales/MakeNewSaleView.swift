import SwiftUI

struct MakeNewSaleView: View {
    @StateObject private var viewModel = MakeNewSaleViewModel()
    @State private var isShowingSelectClientSheet = false
    @State private var saleSubmissionResultMessage = ""
    @State private var showSubmissionAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar and game items list
                HStack {
                    TextField("Enter serial number", text: $viewModel.serialNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit { viewModel.searchGameItem() }
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
                .padding()
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                List {
                    ForEach(viewModel.gameItemInstances) { item in
                        ZStack {
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
                        .background(viewModel.highlightedItemID == item.id ? Color.yellow.opacity(0.5) : Color.clear)
                        .animation(.easeInOut, value: viewModel.highlightedItemID)
                    }
                    .onDelete { offsets in viewModel.removeItems(at: offsets) }
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
                        isShowingSelectClientSheet = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.horizontal)
            }
            .navigationTitle("Make New Sale")
            .sheet(isPresented: $isShowingSelectClientSheet) {
                SelectClientForSaleView(totalPrice: viewModel.totalPrice, saleCompletion: { selectedClient in
                    // If no client is selected, use default
                    let clientPublicId = selectedClient?.id_client_public ?? "default-client-public-id"
                    viewModel.confirmSale(clientPublicId: clientPublicId) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                saleSubmissionResultMessage = "Sale confirmed successfully!"
                                // Dismiss the sheet by setting the binding to false.
                                isShowingSelectClientSheet = false
                            case .failure(let error):
                                saleSubmissionResultMessage = "Sale confirmation failed: \(error.localizedDescription)"
                            }
                            showSubmissionAlert = true
                        }
                    }
                })
            }
            .alert("Result", isPresented: $showSubmissionAlert) {
                Button("OK", role: .cancel) {
                    // Additional reset logic if needed.
                }
            } message: {
                Text(saleSubmissionResultMessage)
            }
        }
    }
}

struct MakeNewSaleView_Previews: PreviewProvider {
    static var previews: some View {
        MakeNewSaleView()
    }
}