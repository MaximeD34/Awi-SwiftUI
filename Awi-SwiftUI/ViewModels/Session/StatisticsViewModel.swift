import SwiftUI
import Combine

class StatisticsViewModel: ObservableObject {
    @Published var statistics: Statistics?
    @Published var loading: Bool = false
    @Published var error: String? = nil
    @Published var sessionId: Int = 1
    
    private let statisticsService = StatisticsService()
    
    func fetchStatistics() {
        loading = true
        error = nil
        statisticsService.fetchStatistics(sessionId: sessionId) { [weak self] result in
            DispatchQueue.main.async {
                self?.loading = false
                switch result {
                case .success(let stats):
                    self?.statistics = stats
                case .failure(let err):
                    self?.error = err.localizedDescription
                }
            }
        }
    }
    
    func refreshStatistics() {
        loading = true
        error = nil
        statisticsService.refreshStatistics { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.fetchStatistics()
                case .failure(let err):
                    self?.loading = false
                    self?.error = err.localizedDescription
                }
            }
        }
    }
}
