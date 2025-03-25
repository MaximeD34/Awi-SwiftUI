//
//  ContentView.swift
//  Awi-SwiftUI
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var loginVM = LoginViewModel()
    
    var body: some View {
        NavigationView {
            if loginVM.isAuthenticated {
                ManagerDashboardView()  // The main screen after login
            } else {
                
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
