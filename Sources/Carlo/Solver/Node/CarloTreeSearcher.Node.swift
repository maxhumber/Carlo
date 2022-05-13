import Foundation

extension CarloTreeSearcher {
    final class Node {
        weak var parent: Node?
        let game: Game
        let move: Move?
        var visits: Int
        var totalValue: Double
        var children: [Node]
        var awaitingExpansion: Bool

        init(parent: Node? = nil, game: Game, previous move: Move? = nil) {
            self.parent = parent
            self.game = game
            self.move = move
            self.visits = 0
            self.totalValue = 0
            self.children = []
            self.awaitingExpansion = true
        }
        
        func selectLeaf() -> Node {
            var node = self
            while !node.awaitingExpansion {
                if let child = node.children.randomElement() {
                    node = child
                } else {
                    break
                }
            }
            return node
        }
        
        func expand() throws {
            defer { awaitingExpansion = false }
            guard awaitingExpansion else { throw CarloError.alreadyExpanded }
            guard game.isInProgress() else { return }
            for move in game.availableMoves() {
                let gamePlus = try! game.after(move)
                let child = Node(parent: self, game: gamePlus, previous: move)
                children.append(child)
            }
        }
        
        func randomPlayout(maxTurns: Int = .max) -> Game {
            var playout = game
            var turns = 0
            while playout.isInProgress() && turns < maxTurns {
                guard let move = playout.randomMove() else { break }
                playout = try! playout.after(move)
                turns += 1
            }
            return playout
        }
        
        func backpropagate(value: Double) {
            visits += 1
            totalValue += value
            if let parent = parent {
                parent.backpropagate(value: value)
            }
        }
    }
}
