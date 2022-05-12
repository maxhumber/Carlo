import Foundation

extension CarloGame {
    var isActive: Bool {
        switch payoff(for: player) {
        case .score: return false
        default: return true
        }
    }
}
