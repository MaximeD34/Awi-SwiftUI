import SwiftUI

struct SellerUpdateView: View {
    @StateObject private var viewModel = SellerDetailViewModel()
    let seller: Seller
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showDeleteConfirmation = false
    @EnvironmentObject var coordinator: NavigationCoordinator  // Centralized navigation
       
    var body: some View {
        Form {
            // Seller Info Section
            Section(header: Text("Seller Information")) {
                TextField("Name", text: $viewModel.sellerName)
                    .autocapitalization(.words)
                if let nameError = viewModel.nameError {
                    Text(nameError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                TextField("Email", text: $viewModel.sellerEmail)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                if let emailError = viewModel.emailError {
                    Text(emailError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                TextField("Telephone", text: $viewModel.sellerTel)
                    .keyboardType(.phonePad)
                if let telError = viewModel.telError {
                    Text(telError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                TextField("Billing Address (optional)", text: $viewModel.sellerBillingAddress)
                if let billingAddressError = viewModel.billingAddressError {
                    Text(billingAddressError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            // Actions Section
            Section {
                HStack {
                    Button(action: {
                        let dto = UpdateSellerDto(
                            name: viewModel.sellerName,
                            email: viewModel.sellerEmail,
                            tel: viewModel.sellerTel,
                            billing_address: viewModel.sellerBillingAddress.isEmpty ? nil : viewModel.sellerBillingAddress
                        )
                        let service = SellerService()
                        service.updateSeller(dto: dto, for: seller) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success:
                                    alertMessage = "Seller updated successfully"
                                    // On update, pop one level.
                                    coordinator.pop(1)
                                case .failure(let error):
                                    alertMessage = error.localizedDescription
                                }
                                showAlert = true
                            }
                        }
                    }) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Text("Delete")
                            .frame(maxWidth: .infinity)
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Update Seller")
        .onAppear {
            viewModel.loadSellerDetails(for: seller)
        }
        .alert("Request Status", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                // No additional action here since pops are already called.
            }
        } message: {
            Text(alertMessage)
        }
        .confirmationDialog("Delete Seller", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                let service = SellerService()
                service.deleteSeller(seller: seller) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            alertMessage = "Seller deleted successfully"
                            // On deletion, pop two levels to remove update and its parent.
                            coordinator.pop(2)
                        case .failure(let error):
                            alertMessage = error.localizedDescription
                        }
                        showAlert = true
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this seller?")
        }
    }
}

struct SellerUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleSeller = Seller(
            id: 1,
            idSellerPublic: "sample-public-id",
            name: "Sample Seller",
            email: "seller@example.com",
            tel: "1234567890",
            billingAddress: "123 Address St."
        )
        NavigationStack {
            SellerUpdateView(seller: sampleSeller)
                .environmentObject(NavigationCoordinator())
        }
    }
}