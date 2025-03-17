import SwiftUI

struct SellerEditView: View {
    @StateObject private var viewModel = SellerDetailViewModel()
    var seller: Seller? // If nil, it can be used to add a new seller
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Seller Information")) {
                    TextField("Name", text: Binding(
                        get: { viewModel.sellerName },
                        set: { viewModel.sellerName = $0 }
                    ))
                    // Add additional fields as needed.
                }
                
                Button("Save") {
                    viewModel.saveSeller(seller)
                }
            }
            .navigationTitle(seller == nil ? "Add Seller" : "Edit Seller")
        }
    }
}

struct SellerEditView_Previews: PreviewProvider {
    static var previews: some View {
        SellerEditView(seller: nil)
    }
}
