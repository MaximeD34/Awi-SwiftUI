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
    @StateObject private var loginVM = LoginViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(loginVM)
        }
    }
}
