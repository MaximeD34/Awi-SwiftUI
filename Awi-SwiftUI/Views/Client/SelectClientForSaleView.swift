import SwiftUI

struct SelectClientForSaleView: View {
    let totalPrice: Double
    // When the sale is to be submitted, this closure returns the selected client (or nil for default)
    var saleCompletion: (Client?) -> Void
    
    @StateObject private var viewModel = ClientsListViewModel()
    @State private var selectedClient: Client? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                // Header: Big Title and Total Price
                VStack(spacing: 4) {
                    Text("Select a Client")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Total Price: $\(totalPrice, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Search Bar
                TextField("Search by name", text: $viewModel.searchName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .onChange(of: viewModel.searchName) { _ in
                        viewModel.currentPage = 1
                    }
                
                // Clients List with compact rows (no grey overlay)
                List {
                    ForEach(viewModel.sellersForCurrentPage(), id: \.id) { client in
                        Button(action: {
                            selectedClient = client
                        }) {
                            HStack {
                                Text(client.name)
                                    .font(.body)
                                Spacer()
                                if selectedClient?.id == client.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    }
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
                    
                    Spacer()
                    
                    Text("Page \(viewModel.currentPage) of \(viewModel.totalPages)")
                        .font(.footnote)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.nextPage()
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(viewModel.currentPage == viewModel.totalPages ? .gray : .blue)
                    }
                    .disabled(viewModel.currentPage == viewModel.totalPages)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                // Confirm button
                Button(action: {
                    saleCompletion(selectedClient)
                }) {
                    Text("Confirm Selection")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedClient == nil ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(selectedClient == nil)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CreateClientView(onClientCreated: { newClient in
                        viewModel.fetchClients()
                        selectedClient = newClient
                    })) {
                        Text("New Client")
                            .fontWeight(.semibold)
                    }
                }
            }
            .onAppear {
                viewModel.fetchClients()
            }
        }
    }
}

struct SelectClientForSaleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelectClientForSaleView(totalPrice: 123.45, saleCompletion: { _ in })
        }
    }
}