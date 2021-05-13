//
//  CarloTactician.swift
//  Created by max on 2021-05-11.
//

import Foundation

/// A Monte Carlo Tree Search Tactician
public final class CarloTactician<Game: CarloGame> {
    /// The player for whom the Tactician will optimize
    public let player: Game.Player
    
    /// The maximum number of "look-ahead" moves in single rollout simulation
    public let maxRolloutDepth: Int
    
    /// The exploration versus exploitation tradeoff constant
    public let explorationConstant: Double
    
    /// The root of the search tree
    public var root: Node?

    /// - Parameter player: Player for whom to optimize
    /// - Parameter maxRolloutDepth: Set to small values if your game is really complex
    /// - Parameter explorationConstant: Better not change unless you have a good reason...
    public init(for player: Game.Player, maxRolloutDepth: Int = .max, explorationConstant: Double = sqrt(2)) {
        self.player = player
        self.maxRolloutDepth = maxRolloutDepth
        self.explorationConstant = explorationConstant
    }
    
    /// Best move (so far) as found by the search algorithm
    public var bestMove: Game.Move? {
        bestNode?.move
    }
    
    /// Best node (so far) as found by the search algorithm
    public var bestNode: Node? {
        root?.selectChildWithMaxUcb(0)
    }
    
    /// Update the root of the tree to the current state of the game
    public func uproot(to game: Game) {
        if let tree = root, let newRoot = findNode(in: tree, holding: game) {
            root = newRoot
        } else {
            root = Node(game)
        }
    }

    /// Perform one "select-rollout-backup" search iteration
    ///
    /// - note: More iterations will lead to better moves. Consequently this method should be run multiple times in a `for`/`while` loop
    public func iterate() {
        if let leaf = select() {
            let value = rollout(leaf)
            backup(value: value, through: leaf)
        }
    }
    
    /// Select a node from the tree according to the explorationConstant
    public func select() -> Node? {
        root?.select(explorationConstant)
    }
    
    /// Simulate a single playthrough until terminal state or max depth is reached
    ///
    /// - returns: The game state value for the player for which the tactician is optimizing
    public func rollout(_ node: Node) -> Double {
        var depth = 0
        var game = node.game
        while !game.isFinished && depth < maxRolloutDepth {
            guard let move = game.randomMove() else {
                break
            }
            game = game.update(move)
            depth += 1
        }
        return game.evaluate(for: player).value
    }
    
    /// Backup the rolled-out value through the entire branch of the tree
    public func backup(value: Double, through node: Node) {
        node.backpropagate(value)
    }
    
    /// Reset root to nil in preparation for a new game
    public func reset() {
        root = nil
    }
        
    private func findNode(in tree: Node, holding game: Game) -> Node? {
        var queue = [tree]
        while !queue.isEmpty {
            let head = queue.removeFirst()
            if head.game == game {
                return head
            }
            queue.append(contentsOf: head.children)
        }
        return nil
    }
}
