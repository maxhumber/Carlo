import Foundation

extension CarloTicTacToe: CustomStringConvertible {
    public var description: String {
        var strings = board.map { $0?.rawValue ?? "*" }
        strings.insert("\n", at: 6)
        strings.insert("\n", at: 3)
        return strings.joined()
    }
}
