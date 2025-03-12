//
//  User.swift
//  Awi-SwiftUI
//
//  Represents the user model with roles for authentication and permissions.
//  Currently supports Admin and Manager roles.
//

import Foundation

enum UserRole: String, Codable {
    case admin
    case manager
}

struct User: Codable, Identifiable {
    let id: UUID
    let name: String
    let email: String
    let role: UserRole
}
