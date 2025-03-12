//
//  ConfigManager.swift
//  Awi-SwiftUI
//
//  Created by etud on 12/03/2025.
//

import Foundation

class ConfigManager {
    static let shared = ConfigManager()
    private var env: [String: String] = [:]

    private init() {
        loadEnv()
    }

    private func loadEnv() {
        guard let path = Bundle.main.path(forResource: ".env", ofType: nil) else {
            print(".env file not found")
            return
        }

        do {
            let contents = try String(contentsOfFile: path)
            let lines = contents.components(separatedBy: .newlines)

            for line in lines {
                let parts = line.components(separatedBy: "=")
                if parts.count == 2 {
                    let key = parts[0].trimmingCharacters(in: .whitespaces)
                    let value = parts[1].trimmingCharacters(in: .whitespaces)
                    env[key] = value
                }
            }
        } catch {
            print("Error loading .env file: \(error)")
        }
    }

    func get(_ key: String) -> String? {
        return env[key]
    }
}
