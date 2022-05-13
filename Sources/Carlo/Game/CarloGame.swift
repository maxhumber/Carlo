import Foundation

public protocol CarloGame {
    associatedtype Player
    associatedtype Move
    var awaiting: Player { get }
    func availableMoves() -> [Move]
    func after(_ move: Move) throws -> Self
    func evaluate(for player: Player) -> CarloPayoff
}
