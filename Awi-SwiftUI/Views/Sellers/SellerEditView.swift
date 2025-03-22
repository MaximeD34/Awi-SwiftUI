import SwiftUI

struct SellerEditView: View {
    @StateObject private var viewModel = SellerDetailViewModel()
    var seller: Seller? // If nil, we're creating a new seller.
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Seller Information")) {
                TextField("Name", text: $viewModel.sellerName)
                    .autocapitalization(.words)
                if let nameError = viewModel.nameError {
                    Text(nameError).foregroundColor(.red).font(.caption)
                }
                
                TextField("Email", text: $viewModel.sellerEmail)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                if let emailError = viewModel.emailError {
                    Text(emailError).foregroundColor(.red).font(.caption)
                }
                
                TextField("Telephone", text: $viewModel.sellerTel)
                    .keyboardType(.phonePad)
                if let telError = viewModel.telError {
                    Text(telError).foregroundColor(.red).font(.caption)
                }
                
                TextField("Billing Address (optional)", text: $viewModel.sellerBillingAddress)
                if let billingAddressError = viewModel.billingAddressError {
                    Text(billingAddressError).foregroundColor(.red).font(.caption)
                }
            }
            
            Button("Save") {
                viewModel.saveSeller(seller) { result in
                    switch result {
                    case .success(let message):
                        alertMessage = message
                        showAlert = true
                    case .failure(let error):
                        alertMessage = error.localizedDescription
                        showAlert = true
                    }
                }
            }
        }
        .navigationTitle(seller == nil ? "Add Seller" : "Edit Seller")
        .onAppear {
            if let seller = seller {
                viewModel.loadSellerDetails(for: seller)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Request Status"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"), action: { dismiss() })
            )
        }
    }
}

struct SellerEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SellerEditView(seller: nil)
        }
    }
}