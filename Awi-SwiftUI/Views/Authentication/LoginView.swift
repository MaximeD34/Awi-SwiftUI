//
//  LoginView.swift
//  Awi-SwiftUI
//
//  Provides the login UI where Managers and Admins can enter their credentials.
//  It binds to a LoginViewModel that handles authentication logic.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome to Awi-SwiftUI")
                .font(.largeTitle)
            
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            if viewModel.isLoading {
                LoadingView()
            }
            
            if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage)
            }
            
            Button("Login") {
                viewModel.login()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
