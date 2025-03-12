//
//  Extensions.swift
//  Awi-SwiftUI
//
//  Contains common Swift extensions to improve code reuse and readability.
//

import SwiftUI

/// A custom button style that gives buttons a primary appearance.
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue.cornerRadius(8))
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

/// An extension on Button to easily apply the primary button style.
extension Button {
    /// Applies the primary button style to the button.
    func primaryButtonStyle() -> some View {
        self.buttonStyle(PrimaryButtonStyle())
    }
}
