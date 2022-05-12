import Foundation

extension CarloGame {
    var isActive: Bool {
        switch payoff(for: player) {
        case .ongoing: return false
        default: return true
        }
    }
}
