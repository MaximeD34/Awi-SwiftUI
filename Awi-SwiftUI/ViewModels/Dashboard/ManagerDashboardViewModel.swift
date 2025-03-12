//
//  ManagerDashboardViewModel.swift
//  Awi-SwiftUI
//
//  Handles business logic for the Manager Dashboard,
//  including fetching recent transactions and seller activities.
//

import Foundation

class ManagerDashboardViewModel: ObservableObject {
    @Published var recentTransactions: [Transaction] = []
    
    func fetchData() {
        // Simulate a network call to fetch transactions.
        // In a real app, this would call a service method.
        recentTransactions = [
            // Adding a placeholder transaction for compilation.
            Transaction(id: UUID(), sellerID: UUID(), gameID: UUID(), type: .sale, quantity: 1, date: Date())
        ]
    }
}
