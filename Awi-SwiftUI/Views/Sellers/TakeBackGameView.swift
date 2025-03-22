import SwiftUI

struct TakeBackGameView: View {
    let seller: Seller
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = TakeBackGameViewModel()
    
    @State private var showResultAlert = false
    @State private var resultMessage = ""
    
    // A computed property to check if there's any selection.
    private var hasSelection: Bool {
        viewModel.depotGames.contains { $0.quantityToTakeBack > 0 } ||
        viewModel.saleGames.contains { $0.quantityToTakeBack > 0 }
    }
    
    var body: some View {
        VStack {
            // Top half: Games on Depot Section.
            if !viewModel.depotGames.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Games on Depot")
                        .font(.headline)
                        .padding([.leading, .top])
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.depotGames.indices, id: \.self) { index in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(viewModel.depotGames[index].name)
                                            .font(.subheadline)
                                        Text(viewModel.depotGames[index].quality)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("$\(viewModel.depotGames[index].sellingPrice, specifier: "%.2f")")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Picker("", selection: $viewModel.depotGames[index].quantityToTakeBack) {
                                        ForEach(0...viewModel.depotGames[index].quantityAvailable, id: \.self) { number in
                                            Text("\(number)").tag(number)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 70, height: 40)
                                    // Fixed width "Max:" label for alignment.
                                    Text("Max: \(viewModel.depotGames[index].quantityAvailable)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .frame(width: 60, alignment: .leading)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    // Force the vertical scroll indicator to always appear.
                    .scrollIndicators(.visible)
                }
                .frame(maxHeight: UIScreen.main.bounds.height / 2)
            }
            
            // Bottom half: Games on Sale Section.
            if !viewModel.saleGames.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Games on Sale")
                        .font(.headline)
                        .padding([.leading, .top])
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.saleGames.indices, id: \.self) { index in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(viewModel.saleGames[index].name)
                                            .font(.subheadline)
                                        Text(viewModel.saleGames[index].quality)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("$\(viewModel.saleGames[index].sellingPrice, specifier: "%.2f")")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Picker("", selection: $viewModel.saleGames[index].quantityToTakeBack) {
                                        ForEach(0...viewModel.saleGames[index].quantityAvailable, id: \.self) { number in
                                            Text("\(number)").tag(number)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 70, height: 40)
                                    // Fixed width "Max:" label for alignment.
                                    Text("Max: \(viewModel.saleGames[index].quantityAvailable)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .frame(width: 60, alignment: .leading)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .scrollIndicators(.visible)
                }
                .frame(maxHeight: UIScreen.main.bounds.height / 2)
            }
            
            // Action buttons: Clear and Retrieve.
            HStack {
                Button(action: {
                    viewModel.cancelSelection()
                }) {
                    Text("Clear")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button("Retrieve") {
                    viewModel.confirmRetrieve { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                resultMessage = "Retrieval confirmed successfully!"
                            case .failure(let error):
                                resultMessage = "Retrieval failed: \(error.localizedDescription)"
                            }
                            showResultAlert = true
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(!hasSelection)
                .opacity(hasSelection ? 1 : 0.5)
            }
            .padding()
        }
        .navigationTitle("Take Back a Game")
        .onAppear {
            viewModel.fetchGames(for: seller)
        }
        .alert("Retrieve Status", isPresented: $showResultAlert) {
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
        NavigationView {
            TakeBackGameView(seller: sampleSeller)
        }
    }
}