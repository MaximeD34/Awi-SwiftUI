import SwiftUI

struct ManageSellersView: View {
    @StateObject private var viewModel = SellerListViewModel()
    @StateObject private var coordinator = NavigationCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack {
                // Title and New button.
                HStack {
                    Text("Manage Sellers")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    NavigationLink(value: "SellerEditView") {
                        Text("New")
                            .padding(8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding([.horizontal, .top])
                
                // Search section.
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
                
                // Seller list.
                List(viewModel.sellersForCurrentPage()) { seller in
                    NavigationLink(value: seller) {
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
                
                // Pagination controls.
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
            .onAppear {
                viewModel.fetchSellers()
            }
            .navigationDestination(for: String.self) { value in
                // Destination for creating a new seller.
                SellerEditView(seller: nil)
                    .environmentObject(coordinator)
            }
            .navigationDestination(for: Seller.self) { seller in
                // Seller actions view.
                SellerActionsView(seller: seller)
                    .environmentObject(coordinator)
            }
        }
        .environmentObject(coordinator)
    }
}

struct ManageSellersView_Previews: PreviewProvider {
    static var previews: some View {
        ManageSellersView()
    }
}