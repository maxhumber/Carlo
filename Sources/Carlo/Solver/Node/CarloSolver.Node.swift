import Foundation

extension CarloSolver {
    final class Node {
        weak var parent: Node?
        var children = [Node]()
        let move: Game.Move?
        let game: Game
        let isTerminal: Bool
        var unexpandedMoves: [Game.Move]
        var cumulativeValue: Double = 0.0
        var visits: Int = 0

        init(_ game: Game, previous move: Game.Move? = nil, parent: Node? = nil) {
            self.parent = parent
            self.move = move
            self.game = game
            self.isTerminal = !game.isActive
            self.unexpandedMoves = game.availableMoves()
        }
        
        var isFullyExpanded: Bool {
            unexpandedMoves.isEmpty
        }
    
        func select(_ c: Double) -> Node {
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
        
        func expand() -> Node {
            let move = unexpandedMoves.popLast()!
            let game = game.updated(move)
            let child = Node(game, previous: move, parent: self)
            children.append(child)
            return child
        }
        
        func backpropagate(_ value: Double, visits n: Int = 1) {
            cumulativeValue += value
            visits += n
            if let parent = parent {
                assert(game.player != parent.game.player, "`currentPlayer` needs to change with every move")
                parent.backpropagate(1 - value, visits: n)
            }
        }
        
        func selectChildWithMaxUcb(_ c: Double) -> Node? {
            children.max { $0.ucb(c) < $1.ucb(c) }
        }
    
        func ucb(_ c: Double) -> Double {
            (cumulativeValue / Double(visits)) + c * sqrt(log(Double(parent!.visits)) / Double(visits))
        }
    }
}
