import Foundation
import Combine

class ClientsListViewModel: ObservableObject {
    @Published var clients: [Client] = []
    @Published var currentPage: Int = 1
    @Published var searchName: String = ""
    
    let pageSize: Int = 10  // adjust page size as needed
    
    private let clientService = ClientService()
    
    var filteredClients: [Client] {
        if searchName.isEmpty {
            return clients
        } else {
            return clients.filter { $0.name.lowercased().contains(searchName.lowercased()) }
        }
    }
    
    var totalPages: Int {
        let count = filteredClients.count
        return count == 0 ? 1 : Int(ceil(Double(count) / Double(pageSize)))
    }
    
    func fetchClients() {
        clientService.fetchClients { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let clients):
                    self?.clients = clients
                    self?.currentPage = 1
                case .failure(let error):
                    print("Error fetching clients: \(error)")
                }
            }
        }
    }
    
    func sellersForCurrentPage() -> [Client] {
        let startIndex = (currentPage - 1) * pageSize
        let endIndex = min(startIndex + pageSize, filteredClients.count)
        if startIndex < endIndex {
            return Array(filteredClients[startIndex..<endIndex])
        }
        return []
    }
    
    func nextPage() {
        if currentPage < totalPages {
            currentPage += 1
        }
    }
    
    func previousPage() {
        if currentPage > 1 {
            currentPage -= 1
        }
    }
}
