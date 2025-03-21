import SwiftUI

struct TakeBackGameView: View {
    let seller: Seller
    var dismissAction: () -> Void
    @StateObject private var viewModel = TakeBackGameViewModel()
    
    @State private var showResultAlert = false
    @State private var resultMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Top half: Games on Depot Section
                VStack(alignment: .leading, spacing: 0) {
                    Text("Games on Depot")
                        .font(.headline)
                        .padding([.leading, .top])
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.depotGames.indices, id: \.self) { index in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(viewModel.depotGames[index].name)
                                            .font(.subheadline)
                                        Text(viewModel.depotGames[index].quality)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Picker("", selection: $viewModel.depotGames[index].quantityToTakeBack) {
                                        ForEach(0...viewModel.depotGames[index].quantityAvailable, id: \.self) { number in
                                            Text("\(number)").tag(number)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 70, height: 40)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .frame(maxHeight: UIScreen.main.bounds.height / 2)
                
                // Bottom half: Games on Sale Section
                VStack(alignment: .leading, spacing: 0) {
                    Text("Games on Sale")
                        .font(.headline)
                        .padding([.leading, .top])
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.saleGames.indices, id: \.self) { index in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(viewModel.saleGames[index].name)
                                            .font(.subheadline)
                                        Text(viewModel.saleGames[index].quality)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Picker("", selection: $viewModel.saleGames[index].quantityToTakeBack) {
                                        ForEach(0...viewModel.saleGames[index].quantityAvailable, id: \.self) { number in
                                            Text("\(number)").tag(number)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 70, height: 40)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .frame(maxHeight: UIScreen.main.bounds.height / 2)
                
                // Action buttons: Cancel and Retrieve with equal sizes
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
                }
                .padding()
            }
            .navigationTitle("Take Back a Game")
            .navigationBarItems(leading:
                Button(action: dismissAction) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            )
            .onAppear {
                viewModel.fetchGames(for: seller)
            }
            .alert("Retrieve Status", isPresented: $showResultAlert) {
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
        TakeBackGameView(seller: sampleSeller, dismissAction: {})
    }
}