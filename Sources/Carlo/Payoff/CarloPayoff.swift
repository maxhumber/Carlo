import Foundation

public enum CarloPayoff: Equatable {
    case win
    case loss
    case draw
    case score(Double = 0.5)
}
