import SwiftUI

final class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    // Pop the specified number of levels from the navigation path.
    func pop(_ count: Int = 1) {
        for _ in 0..<count {
            if !path.isEmpty {
                path.removeLast()
            }
        }
    }
}