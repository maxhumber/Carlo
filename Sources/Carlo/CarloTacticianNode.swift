//
//  CarloTacticianNode.swift
//  Created by max on 2021-05-11.
//

import Foundation

extension CarloTactician {
    public final class Node: CustomStringConvertible {
        public weak var parent: Node?
        public var move: Game.Move?
        public let game: Game
        public var unexpandedMoves: [Game.Move]
        public var children = [Node]()
        public var cumulativeValue = 0.0
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
        
        public var description: String {
            let percentString = String(format: "%.0f", percent*100) + "%"
            let visitsString = String(format: "%.0f", visits)
            return "\(cumulativeValue)/\(visitsString) (\(percentString))"
        }
        
        public var percent: Double {
            round(cumulativeValue/visits * 100) / 100
        }
        
        public var isFullyExpanded: Bool {
            unexpandedMoves.isEmpty
        }
        
        public lazy var isTerminal: Bool = {
            game.isFinished
        }()
        
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
        
        public func expand() -> Node {
            let move = unexpandedMoves.popLast()!
            let nextCarloGame = game.update(move)
            let childNode = Node(parent: self, move: move, game: nextCarloGame)
            children.append(childNode)
            return childNode
        }
        
        public func backpropagate(_ value: Double) {
            visits += 1
            cumulativeValue += value
            if let parent = parent {
                parent.backpropagate(value)
            }
        }
        
        public func selectChildWithMaxUcb(_ c: Double) -> Node? {
            children.max { $0.ucb(c) < $1.ucb(c) }
        }
        
        private func ucb(_ c: Double) -> Double {
            (cumulativeValue / Double(visits)) + c * sqrt(log(parent!.visits) / visits)
        }
    }
}
