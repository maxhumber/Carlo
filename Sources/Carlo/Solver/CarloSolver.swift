import Foundation

public final class CarloSolver<Game: CarloGame> {
    let player: Game.Player
    let maxRolloutDepth: Int
    let explorationConstant: Double
    var root: Node?
    
    /// - Parameter player: CPU player
    /// - Parameter maxRolloutDepth: Set to small values if your game is really complex
    /// - Parameter explorationConstant: Don't change unless you know what you're doing...
    public init(_ player: Game.Player, maxRolloutDepth: Int = .max, explorationConstant: Double = sqrt(2)) {
        self.player = player
        self.maxRolloutDepth = maxRolloutDepth
        self.explorationConstant = explorationConstant
    }
    
    public func pickup(to game: Game) {
        if let tree = root, let newRoot = findNode(in: tree, holding: game) {
            root = newRoot
        } else {
            root = Node(game)
        }
    }
    
    /// Perform one search iteration
    public func search() {
        if let leaf = select() {
            let value = rollout(leaf)
            backup(value, through: leaf)
        }
    }
    
    public var bestMove: Game.Move? {
        bestNode?.move
    }

    var bestNode: Node? {
        root?.selectChildWithMaxUcb(0)
    }

    func select() -> Node? {
        root?.select(explorationConstant)
    }
    
    func rollout(_ node: Node) -> Double {
        var depth = 0
        var game = node.game
        while game.isActive && depth < maxRolloutDepth {
            guard let move = game.randomMove() else { break }
            game = game.updated(move)
            depth += 1
        }
        let payoff = game.payoff(for: player)
        return payoff.value
    }
    
    func backup(_ value: Double, visits n: Int = 1, through node: Node) {
        node.backpropagate(value, visits: n)
    }
    
    func findNode(in tree: Node, holding game: Game) -> Node? {
        var queue = [tree]
        while !queue.isEmpty {
            let head = queue.removeFirst()
            if head.game == game { return head }
            queue.append(contentsOf: head.children)
        }
        return nil
    }
}
