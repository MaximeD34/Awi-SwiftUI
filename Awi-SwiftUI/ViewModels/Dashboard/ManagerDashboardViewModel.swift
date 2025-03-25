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
       
        recentTransactions = [
            Transaction(id: UUID(), sellerID: UUID(), gameID: UUID(), type: .sale, quantity: 1, date: Date())
        ]
    }
}
