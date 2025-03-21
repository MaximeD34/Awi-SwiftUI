import SwiftUI

struct ManageSellersView: View {
    @StateObject private var viewModel = SellerListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Plain Search Field without gray background.
                VStack(alignment: .leading, spacing: 8) {
                    Text("Search Sellers")
                        .font(.headline)
                    TextField("Name", text: $viewModel.searchName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Search") {
                        viewModel.filterSellers()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Seller List (paged) with navigation to SellerActionsView.
                List(viewModel.sellersForCurrentPage()) { seller in
                    NavigationLink(destination: SellerActionsView(seller: seller)) {
                        HStack {
                            Text(seller.name)
                            Spacer()
                            if seller.id == viewModel.selectedSeller?.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .contentShape(Rectangle())
                }
                .listStyle(PlainListStyle())
                
                // Pagination controls
                HStack {
                    Button(action: {
                        viewModel.previousPage()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(viewModel.currentPage == 1 ? .gray : .blue)
                    }
                    .disabled(viewModel.currentPage == 1)
                    
                    Text("Page \(viewModel.currentPage) of \(viewModel.totalPages)")
                        .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        viewModel.nextPage()
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(viewModel.currentPage == viewModel.totalPages ? .gray : .blue)
                    }
                    .disabled(viewModel.currentPage == viewModel.totalPages)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Manage Sellers")
            .onAppear {
                viewModel.fetchSellers()
            }
        }
    }
}

struct ManageSellersView_Previews: PreviewProvider {
    static var previews: some View {
        ManageSellersView()
    }
}