// filepath: /Users/etud/Documents/Awi-SwiftUI/Awi-SwiftUI/Views/Authentication/RootView.swift
import SwiftUI

struct RootView: View {
    @EnvironmentObject var loginVM: LoginViewModel

    var body: some View {
        Group {
            if loginVM.isAuthenticated {
                ManagerDashboardView()
            } else {
                LoginView()
            }
        }
//        .onChange(of: loginVM.isAuthenticated) { newValue in
//            print("Authentication state changed to: \(newValue)")
//        }
    }
}
