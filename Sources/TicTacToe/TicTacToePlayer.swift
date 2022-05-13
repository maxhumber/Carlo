import Foundation

public enum TicTacToePlayer: String, Equatable {
    case x = "X"
    case o = "O"
    
    var opponent: Self {
        switch self {
        case .x: return .o
        case .o: return .x
        }
    }
}

