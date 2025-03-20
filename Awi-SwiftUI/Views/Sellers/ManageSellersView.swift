import SwiftUI

struct ManageSellersView: View {
    @StateObject private var viewModel = SellerListViewModel()
    @State private var sellerAction: SellerAction? = nil
    
    var body: some View {
        ZStack {
            VStack {
                // Single Search Field for seller name.
                Form {
                    Section(header: Text("Search Sellers")) {
                        TextField("Name", text: $viewModel.searchName)
                        Button("Search") {
                            viewModel.filterSellers()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
                .padding(.horizontal)
                
                // Seller List (paged)
                List(viewModel.sellersForCurrentPage()) { seller in
                    HStack {
                        Text(seller.name)
                        Spacer()
                        if seller.id == viewModel.selectedSeller?.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.selectSeller(seller)
                    }
                }
                
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
                
                if let _ = viewModel.selectedSeller {
                    HStack(spacing: 20) {
                        Button("Add a Game to Deposit") {
                            sellerAction = .addDeposit
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        
                        Button("Put a Game on Sale") {
                            sellerAction = .putOnSale
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        
                        Button("Take Back a Game") {
                            sellerAction = .takeBack
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Manage Sellers")
            .onAppear {
                viewModel.fetchSellers()
            }
            
            if let action = sellerAction, let selectedSeller = viewModel.selectedSeller {
                // Dimming background covering the entire screen.
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        // You can still dismiss by tapping outside if desired.
                        sellerAction = nil
                    }
                
                // Overlay now fills the entire screen without animation on dismiss.
                Group {
                    switch action {
                    case .addDeposit:
                        AddGameToDepositView(seller: selectedSeller, dismissAction: { sellerAction = nil })
                    case .putOnSale:
                        PutGameOnSaleView(seller: selectedSeller, dismissAction: { sellerAction = nil })
                    case .takeBack:
                        TakeBackGameView(seller: selectedSeller, dismissAction: { sellerAction = nil })
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .ignoresSafeArea()
                .transition(.move(edge: .trailing))
            }
        }
    }
}