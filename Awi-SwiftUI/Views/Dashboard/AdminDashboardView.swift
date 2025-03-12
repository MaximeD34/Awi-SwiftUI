//
//  AdminDashboardView.swift
//  Awi-SwiftUI
//
//  Dashboard view for Admin users.
//  Admins can manage Managers and view overall statistics.
//

import SwiftUI

struct AdminDashboardView: View {
    // This view would have its own view model if needed
    var body: some View {
        NavigationView {
            VStack {
                Text("Admin Dashboard")
                    .font(.title)
                // Content and navigation links to manage managers, etc.
                NavigationLink(destination: Text("Manage Managers Screen")) {
                    Text("Manage Managers")
                }
            }
            .navigationTitle("Admin")
        }
    }
}

struct AdminDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        AdminDashboardView()
    }
}
