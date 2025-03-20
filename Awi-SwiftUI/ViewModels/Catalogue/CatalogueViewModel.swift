import Foundation

class CatalogueViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var currentPage: Int = 1
    @Published var pageSize: Int = 7
    @Published var totalPages: Int = 1   // New property for total pages

    private let gameService = GameService()
    
    func fetchGames() {
        gameService.fetchGames(page: currentPage, pageSize: pageSize) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.games = response.data
                    // Update currentPage and totalPages from the pagination info.
                    self?.currentPage = response.pagination.current_page
                    self?.totalPages = response.pagination.total_pages
                case .failure(let error):
                    print("Error fetching games: \(error)")
                }
            }
        }
    }
    
    func nextPage() {
        if currentPage < totalPages {
            currentPage += 1
            fetchGames()
        }
    }
    
    func previousPage() {
        if currentPage > 1 {
            currentPage -= 1
            fetchGames()
        }
    }
}