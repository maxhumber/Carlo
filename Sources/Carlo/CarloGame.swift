//
//  CarloGame.swift
//  Created by max on 2021-05-11.
//

import Foundation

/// A representation of a game state
///
/// - requires: Must be an immutable value type (a struct)
public protocol CarloGame: Equatable {
    /// A representation of a game player
    associatedtype Player: CarloGamePlayer
    
    /// A representation of a game move
    associatedtype Move: CarloGameMove
    
    /// Alias for the evaluation enum
    typealias Evaluation = CarloGameEvaluation
    
    /// Player who is able to make/take the next move
    var currentPlayer: Player { get }
    
    /// Legal moves available to the current player
    func availableMoves() -> [Move]
    
    /// Process a player's move and advance the game
    ///
    /// - returns: an updated game state struct
    func update(_ move: Move) -> Self
    
    /// Evaluate the game at the current state for the corresponding player
    func evaluate(for player: Player) -> Evaluation
}

extension CarloGame {
    /// A random move from the array of legal moves available to the current player
    public func randomMove() -> Move? {
        availableMoves().randomElement()
    }
    
    /// Shorthand evaluation for the current player
    public func evaluate() -> Evaluation {
        evaluate(for: currentPlayer)
    }

    /// Flag for whether the game has reached a terminal state
    ///
    /// - returns: `false` if `evaluate()` is `.ongoing(_)`, otherwise `true`
    public var isFinished: Bool {
        switch evaluate() {
        case .ongoing: return false
        default: return true
        }
    }
}
