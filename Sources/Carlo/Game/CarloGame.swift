import Foundation

public protocol CarloGame: Equatable {
    associatedtype Move
    associatedtype Player: Equatable
    // current player, to be switched after move and payoff calculation
    var player: Player { get }
    func availableMoves() -> [Move]
    func updated(_ move: Move) -> Self
    func payoff(for player: Player) -> CarloPayoff
}
