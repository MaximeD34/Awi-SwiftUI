//
//  Helpers.swift
//  Awi-SwiftUI
//
//  Contains helper functions used across the project.
//  For example, formatting dates or logging.
//

import Foundation

struct Helpers {
    /// Formats a date into a user-friendly string.
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // Add more helper functions as needed.
}
