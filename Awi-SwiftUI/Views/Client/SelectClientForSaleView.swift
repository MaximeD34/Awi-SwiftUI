import SwiftUI

struct SelectClientForSaleView: View {
    let totalPrice: Double
    // When the sale is to be submitted, this closure returns the selected client (or nil for default)
    var saleCompletion: (Client?) -> Void
    
    @StateObject private var viewModel = ClientsListViewModel()
    @State private var selectedClient: Client? = nil
    
    var body: some View {
        VStack {
            // Header with total price and "Create New Client" button
            HStack {
                Text("Total Price: $\(totalPrice, specifier: "%.2f")")
                    .font(.title2)
                    .padding(.leading)
                Spacer()
                NavigationLink("Create New Client", destination: CreateClientView(onClientCreated: { newClient in
                    // Refresh list and select the new client.
                    viewModel.fetchClients()
                    selectedClient = newClient
                }))
                .padding(.trailing)
            }
            .padding(.vertical, 4)
            
            // Search bar
            TextField("Search by name", text: $viewModel.searchName, prompt: Text("Search clients"))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.horizontal, .top])
                .onChange(of: viewModel.searchName) { _ in
                    viewModel.currentPage = 1
                }
            
            // Clients list
            List(viewModel.sellersForCurrentPage()) { client in
                HStack {
                    Text(client.name)
                    Spacer()
                    if selectedClient?.id == client.id {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedClient = client
                }
            }
            .listStyle(PlainListStyle())
            
            // Pagination controls
            HStack {
                Button(action: { viewModel.previousPage() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(viewModel.currentPage == 1 ? .gray : .blue)
                }
                .disabled(viewModel.currentPage == 1)
                
                Spacer()
                Text("Page \(viewModel.currentPage) of \(viewModel.totalPages)")
                Spacer()
                
                Button(action: { viewModel.nextPage() }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(viewModel.currentPage == viewModel.totalPages ? .gray : .blue)
                }
                .disabled(viewModel.currentPage == viewModel.totalPages)
            }
            .padding(.horizontal)
            
            // Confirm button at bottom
            Button(action: {
                saleCompletion(selectedClient)
            }) {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedClient == nil ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(selectedClient == nil)
            .padding()
        }
        .navigationTitle("Select Client")
        .onAppear {
            viewModel.fetchClients()
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
