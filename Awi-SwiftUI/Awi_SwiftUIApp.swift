//
//  Awi_SwiftUIApp.swift
//  Awi-SwiftUI
//
//  Created by maxime.
//
//  Main entry point for the SwiftUI app. This file sets up the root view
//  and environment objects (like authentication status) needed throughout the app.
//

import SwiftUI

@main
struct Awi_SwiftUIApp: App {
    // You can inject your view models or services here as environment objects.
    @StateObject private var loginVM = LoginViewModel()
    
    var body: some Scene {
        WindowGroup {
            // Decide the initial view based on auth state.
            if loginVM.isAuthenticated {
                // For example, show the appropriate dashboard
                ManagerDashboardView()
            } else {
                LoginView()
            }
        }
        
    }
}
