import SwiftUI

struct GameItemDetailView: View {
    let game: Game
    
    // State for holding instances
    @State private var instances: [GameItemInstanceExtended] = []
    @State private var isLoadingInstances = false
    @State private var instancesErrorMessage: String?
    
    // State for showing copied feedback.
    @State private var showCopiedToast = false
    // Optionally, store the serial that was copied (if you wish to show it).
    @State private var copiedSerial: String?
    
    private let instanceService = GameItemInstanceService()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                // Centered seller info card.
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        NavigationLink(destination: BoardGameDetailView(bgDetail: game.bgDetail)) {
                            Text(game.title)
                                .font(.headline)
                                .underline()
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Text("Status: \(game.condition)")
                            .font(.subheadline)
                        Text("Price: $\(game.price, specifier: "%.2f")")
                            .font(.subheadline)
                        if let sellerName = game.seller?.name {
                            Text("Seller: \(sellerName)")
                                .font(.subheadline)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                // Section title.
                Text("Serial Numbers")
                    .font(.headline)
                    .padding(.horizontal)
                
                if isLoadingInstances {
                    ProgressView("Loading Serial Numbers...")
                        .padding(.horizontal)
                } else if let errorMessage = instancesErrorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding(.horizontal)
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(instances) { instance in
                                HStack(spacing: 12) {
                                    Image(systemName: "barcode.viewfinder")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Serial Number")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(instance.serialNumber)
                                            .font(.body)
                                            .fontWeight(.semibold)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(UIColor.systemBackground))
                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                                )
                                .padding(.horizontal)
                                .onTapGesture {
                                    // Copy serial number to clipboard.
                                    UIPasteboard.general.string = instance.serialNumber
                                    copiedSerial = instance.serialNumber
                                    withAnimation {
                                        showCopiedToast = true
                                    }
                                    // Hide the toast after 2 seconds.
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            showCopiedToast = false
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                Spacer()
            }
            .navigationTitle("Game Item Details")
            .navigationBarTitleDisplayMode(.inline)
            // Toast overlay
            if showCopiedToast {
                VStack {
                    Spacer()
                    Text("Copied!")
                        .font(.headline)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .transition(.opacity)
                        .padding(.bottom, 40)
                }
            }
        }
        .onAppear(perform: loadInstances)
    }
    
    private func loadInstances() {
        isLoadingInstances = true
        instancesErrorMessage = nil
        
        // Call the new method using the game_inventory_item_public (game.publicId).
        instanceService.fetchInstances(forPublicId: game.publicId) { result in
            DispatchQueue.main.async {
                isLoadingInstances = false
                switch result {
                case .success(let instances):
                    self.instances = instances
                case .failure(let error):
                    self.instancesErrorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct GameItemDetailView_Previews: PreviewProvider {
    static let sampleSeller = Seller(
        id: 1,
        idSellerPublic: "sample-public-id",
        name: "Houston Hobby",
        email: "houstonhobby@example.com",
        tel: "555-3456",
        billingAddress: "101 Game Pl, Houston"
    )
    
    static let sampleGame: Game = {
        var game = Game(
            id: 1,
            title: "Sample Game",
            description: "A fun board game",
            price: 29.99,
            inventoryCount: 10,
            condition: "New",
            publicId: "f70ffda0-7a75-42e2-b93d-a1995c13fada", // Must match the backend's game_inventory_item_public.
            yearPublished: nil,
            minPlayers: nil,
            maxPlayers: nil,
            minAge: nil,
            minPlaytime: nil,
            idEditorPublic: nil,
            editorName: nil
        )
        game.seller = sampleSeller
        return game
    }()
    
    static var previews: some View {
        NavigationView {
            GameItemDetailView(game: sampleGame)
        }
    }
}