import Foundation

public protocol CarloGame: Equatable {
    associatedtype Move
    associatedtype Player: Equatable
    var awaiting: Player { get }
    func availableMoves() -> [Move]
    func after(_ move: Move) throws -> Self
    func evaluate(for player: Player) -> CarloPayoff
}
