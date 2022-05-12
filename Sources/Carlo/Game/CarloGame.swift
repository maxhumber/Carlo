import Foundation

public protocol CarloGame: Equatable {
    associatedtype Move
    associatedtype Player: Equatable
    var player: Player { get } // switch after move
    func availableMoves() -> [Move]
    func after(_ move: Move) -> Self
    func payoff(for player: Player) -> CarloPayoff
}
