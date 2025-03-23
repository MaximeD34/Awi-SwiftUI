import SwiftUI

struct PurchaseDetailView: View {
    let purchase: ClientPurchase
    @StateObject private var viewModel = PurchaseDetailViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading instances...")
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(viewModel.instances) { instance in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Serial: \(instance.serialNumber)")
                            .font(.headline)
                        if let gameName = instance.gameInventoryItem.bg?.name {
                            Text("Game: \(gameName)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Quality: \(instance.gameInventoryItem.status)")
                                .font(.subheadline)
                            Spacer()
                            Text("$\(instance.gameInventoryItem.price, specifier: "%.2f")")
                                .font(.subheadline)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Purchase on \(formattedDate(purchase.date))")
        .onAppear {
            viewModel.fetchInstances(for: purchase.id_purchase_public)
        }
    }
    
    private func formattedDate(_ isoDate: String) -> String {
        // For simplicity, return the ISO date.
        return isoDate
    }
}

struct PurchaseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePurchase = ClientPurchase(
            id_purchase: 4,
            id_purchase_public: "fbae4458-4f66-465c-95ee-19b1fdc1b944",
            date: "2025-03-23T21:19:56.724Z",
            id_client_public: "d05c2918-f035-46dd-a6be-1e093bb7a62f",
            id_manager_public: "08975f33-8bd7-45e2-b910-4797e1a38ef5"
        )
        NavigationView {
            PurchaseDetailView(purchase: samplePurchase)
        }
    }
}
