import Foundation

extension CarloPayoff {
    var value: Double {
        switch self {
        case .win: return 1
        case .loss: return 0
        case .draw: return 0.5
        case .ongoing(let value): return value
        }
    }
}
