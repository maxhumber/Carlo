import Foundation

extension TicTacToePlayer {
    var opponent: Self {
        switch self {
        case .x: return .o
        case .o: return .x
        }
    }
}

