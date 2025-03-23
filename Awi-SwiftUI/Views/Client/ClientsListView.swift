import SwiftUI

struct ClientsListView: View {
    @StateObject private var viewModel = ClientsListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar (Optional)
                TextField("Search by name", text: $viewModel.searchName, prompt: Text("Search clients"))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: viewModel.searchName) { _ in
                        viewModel.currentPage = 1
                    }
                
                // List of clients
                List(viewModel.sellersForCurrentPage()) { client in
                    NavigationLink(destination: ClientDetailView(client: client)) {
                        Text(client.name)
                            .font(.body)
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
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.nextPage()
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(viewModel.currentPage == viewModel.totalPages ? .gray : .blue)
                    }
                    .disabled(viewModel.currentPage == viewModel.totalPages)
                }
                .padding()
            }
            .navigationTitle("Clients")
            .onAppear {
                viewModel.fetchClients()
            }
        }
    }
}

struct ClientsListView_Previews: PreviewProvider {
    static var previews: some View {
        ClientsListView()
    }
}
