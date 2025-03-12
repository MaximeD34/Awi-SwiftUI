import Foundation

struct Constants {
    static let API_BASE_URL = ConfigManager.shared.get("API_BASE_URL") ?? "https://default-url.com"
    static let LOGIN_ENDPOINT = ConfigManager.shared.get("LOGIN_ENDPOINT") ?? "/auth/login"
    static let REGISTER_ENDPOINT = ConfigManager.shared.get("REGISTER_ENDPOINT") ?? "/auth/register"
}
