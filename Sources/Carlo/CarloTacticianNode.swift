//
//  CarloTacticianNode.swift
//  Created by max on 2021-05-11.
//

import Foundation

extension CarloTactician {
    /// Tree Node for the Tactian's search algorithm
    public final class Node: CustomStringConvertible {
        /// A reference to the node's parent if it exists
        public weak var parent: Node?
        
        /// The move that was taken to arrive at this node
        public var move: Game.Move?
        
        /// The current game state after the move was taken
        public let game: Game
        
        /// The array of moves that have not yet been explored
        public var unexpandedMoves: [Game.Move]
        
        /// The child nodes of this current one
        public var children = [Node]()
        
        /// The cumulative value backpropagated to this node
        public var cumulativeValue = 0.0
        
        /// The number of visits this node has recieved
        public var visits = 0.0

        public init(parent: Node? = nil, move: Game.Move? = nil, game: Game) {
            self.parent = parent
            self.move = move
            self.game = game
            self.unexpandedMoves = game.availableMoves()
        }
        
        public init(_ game: Game) {
            self.parent = nil
            self.move = nil
            self.game = game
            self.unexpandedMoves = game.availableMoves()
        }
        
        /// Quick look description
        public var description: String {
            let percentString = String(format: "%.0f", percent*100) + "%"
            let visitsString = String(format: "%.0f", visits)
            return "\(cumulativeValue)/\(visitsString) (\(percentString))"
        }
        
        /// Value percentage based on number of visits
        public var percent: Double {
            round(cumulativeValue/visits * 100) / 100
        }
        
        /// Flag for whether all of the possible child moves have been explored
        public var isFullyExpanded: Bool {
            unexpandedMoves.isEmpty
        }
        
        /// Flag for whether this node contains a terminal game state
        public lazy var isTerminal: Bool = {
            game.isFinished
        }()
        
        /// The node selection policy
        public func select(_ c: Double) -> Node {
            var leafNode = self
            while !leafNode.isTerminal {
                if !leafNode.isFullyExpanded {
                    return leafNode.expand()
                } else {
                    leafNode = leafNode.selectChildWithMaxUcb(c)!
                }
            }
            return leafNode
        }
        
        /// The expanding method for if there are still unexpanded moves on this node
        public func expand() -> Node {
            let move = unexpandedMoves.popLast()!
            let nextCarloGame = game.update(move)
            let childNode = Node(parent: self, move: move, game: nextCarloGame)
            children.append(childNode)
            return childNode
        }
        
        /// Backpropagate the rollout value through the entire branch of the tree
        public func backpropagate(_ value: Double, visits n: Double = 1) {
            cumulativeValue += value
            visits += n
            if let parent = parent {
                assert(game.currentPlayer != parent.game.currentPlayer, "`currentPlayer` needs to change with every move")
                parent.backpropagate(1 - value, visits: n)
            }
        }
        
        /// Select the best child with the best Upper Confidence Bounds
        public func selectChildWithMaxUcb(_ c: Double) -> Node? {
            children.max { $0.ucb(c) < $1.ucb(c) }
        }
        
        /// The Upper Confidence Bounds for this node
        private func ucb(_ c: Double) -> Double {
            (cumulativeValue / Double(visits)) + c * sqrt(log(parent!.visits) / visits)
        }
    }
}
