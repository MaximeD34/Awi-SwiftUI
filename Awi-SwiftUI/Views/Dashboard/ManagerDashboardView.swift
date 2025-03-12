//
//  ManagerDashboardView.swift
//  Awi-SwiftUI
//
//  Dashboard view for Managers.
//  Displays seller activity, transactions, and provides navigation to seller management.
//

import SwiftUI

struct ManagerDashboardView: View {
    @StateObject private var viewModel = ManagerDashboardViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Recent Transactions")) {
                    // Example list of transactions; in a real app, you'd show more details.
                    ForEach(viewModel.recentTransactions) { transaction in
                        Text("Transaction: \(transaction.type.rawValue.capitalized) \(transaction.quantity)")
                    }
                }
            }
            .navigationTitle("Manager Dashboard")
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}

struct ManagerDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        ManagerDashboardView()
    }
}
