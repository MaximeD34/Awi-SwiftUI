import SwiftUI

struct ClientDetailView: View {
    let client: Client
    @State private var clientPurchases: [ClientPurchase] = []
    @State private var purchasesLoading: Bool = false
    @State private var purchasesErrorMessage: String? = nil
    
    private let purchaseService = PurchaseService()
    
    var body: some View {
        Form {
            // Client Information Section
            Section(header: Text("Client Information")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(client.name)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Email")
                    Spacer()
                    Text(client.email)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Phone")
                    Spacer()
                    Text(client.num)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Address")
                    Spacer()
                    Text(client.address)
                        .foregroundColor(.secondary)
                }
            }
            
            // Purchases Section
            Section(header: Text("Purchases")) {
                if purchasesLoading {
                    HStack {
                        Spacer()
                        ProgressView("Loading Purchases...")
                        Spacer()
                    }
                } else if let message = purchasesErrorMessage {
                    Text(message)
                        .foregroundColor(.red)
                } else if clientPurchases.isEmpty {
                    Text("No purchases found.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(clientPurchases) { purchase in
                        NavigationLink(destination: PurchaseDetailView(purchase: purchase)) {
                            Text(formattedDate(purchase.date))
                        }
                    }
                }
            }
        }
        .navigationTitle(client.name)
        .onAppear {
            fetchPurchases()
        }
    }
    
    private func fetchPurchases() {
        purchasesLoading = true
        purchasesErrorMessage = nil
        purchaseService.fetchClientPurchases(clientPublicId: client.id_client_public) { result in
            DispatchQueue.main.async {
                purchasesLoading = false
                switch result {
                case .success(let purchases):
                    self.clientPurchases = purchases
                case .failure(let error):
                    self.purchasesErrorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func formattedDate(_ isoDate: String) -> String {
        // For simplicity, return the ISO date. You can implement DateFormatter if needed.
        return isoDate
    }
}

struct ClientDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleClient = Client(
            id_client: 1,
            id_client_public: "d05c2918-f035-46dd-a6be-1e093bb7a62f",
            address: "789 Elm St",
            num: "555-1001",
            email: "alice@example.com",
            name: "Alice Smith",
            id_town_public: "2d55174a-c633-429c-b165-8644d0801657"
        )
        NavigationView {
            ClientDetailView(client: sampleClient)
        }
    }
}