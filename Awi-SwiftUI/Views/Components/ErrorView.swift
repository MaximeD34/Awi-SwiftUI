//
//  ErrorView.swift
//  Awi-SwiftUI
//
//  A reusable view to display error messages in a consistent style.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.red)
            .padding()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "An error occurred")
    }
}
