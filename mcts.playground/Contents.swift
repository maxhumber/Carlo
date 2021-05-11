import Foundation

// Required Structs

public protocol CarloGame: Equatable {
    associatedtype Player: CarloGamePlayer
    associatedtype Move: CarloGameMove
    typealias Evaluation = CarloGameEvaluation
    
    var currentPlayer: Player { get }
    var isFinished: Bool { get }
    func availableMoves() -> [Move]
    func update(_ move: Move) -> Self
    func evaluate(for player: Player) -> Evaluation
}

extension CarloGame {
    public func randomMove() -> Move? {
        availableMoves().randomElement()
    }
    
    public func evaluate() -> Evaluation {
        evaluate(for: currentPlayer)
    }
}

public enum CarloGameEvaluation {
    case win
    case loss
    case draw
    case ongoing(Double)
    
    public var value: Double {
        switch self {
        case .win: return 1
        case .loss: return 0
        case .draw: return 0.5
        case .ongoing(let ongoingValue): return ongoingValue
        }
    }
}

public protocol CarloGameMove {}

public protocol CarloGamePlayer {}

// Monte Carlo Tree Search Implementation

public final class CarloTactician<Game: CarloGame> {
    public let player: Game.Player
    public let maxRolloutDepth: Int
    public let explorationConstant: Double
    public var root: Node?
    private var iterating = false

    public init(for player: Game.Player, maxRolloutDepth: Int = .max, explorationConstant: Double = sqrt(2)) {
        self.player = player
        self.maxRolloutDepth = maxRolloutDepth
        self.explorationConstant = explorationConstant
    }
    
    public var bestMove: Game.Move? {
        bestNode?.move
    }
    
    public var bestNode: Node? {
        root?.selectChildWithMaxUcb(0)
    }
    
    public func uproot(to game: Game) {
        if let tree = root, let newRoot = findNode(in: tree, holding: game) {
            root = newRoot
        } else {
            root = Node(game)
        }
    }

    public func iterate() {
        if let leaf = select() {
            let value = rollout(leaf)
            backup(value: value, through: leaf)
        }
    }
    
    public func select() -> Node? {
        root?.select(explorationConstant)
    }
    
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
    
    public func backup(value: Double, through node: Node) {
        node.backpropagate(value)
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

// Test CarloGame

enum ConnectThreePlayer: Int, CarloGamePlayer {
    case one = 1
    case two = 2
    
    var opposite: Self {
        switch self {
        case .one: return .two
        case .two: return .one
        }
    }
}

extension ConnectThreePlayer: CustomStringConvertible {
    var description: String {
        "\(rawValue)"
    }
}

typealias ConnectThreeMove = Int

extension ConnectThreeMove: CarloGameMove {}

struct ConnectThreeGame: CarloGame {
    typealias Player = ConnectThreePlayer
    typealias Move = ConnectThreeMove

    var array: Array<Int>
    var currentPlayer: Player
    
    init(length: Int = 10, currentPlayer: Player = .one) {
        self.array = Array.init(repeating: 0, count: length)
        self.currentPlayer = currentPlayer
    }
    
    var isFinished: Bool {
        switch evaluate() {
        case .ongoing: return false
        default: return true
        }
    }

    func availableMoves() -> [Move] {
        array
            .enumerated()
            .compactMap { $0.element == 0 ? Move($0.offset) : nil}
    }
    
    func update(_ move: Move) -> Self {
        var copy = self
        copy.array[move] = currentPlayer.rawValue
        copy.currentPlayer = currentPlayer.opposite
        return copy
    }
    
    func evaluate(for player: Player) -> Evaluation {
        let player3 = three(for: player)
        let oppo3 = three(for: player.opposite)
        let remaining0 = array.contains(0)
        switch (player3, oppo3, remaining0) {
        case (true, true, _): return .draw
        case (true, false, _): return .win
        case (false, true, _): return .loss
        case (false, false, false): return .draw
        default: return .ongoing(0.5)
        }
    }
}

extension ConnectThreeGame {
    private func three(for player: Player) -> Bool {
        var count = 0
        for slot in array {
            if slot == player.rawValue {
                count += 1
            } else {
                count = 0
            }
            if count == 3 {
                return true
            }
        }
        return false
    }
}

extension ConnectThreeGame: CustomStringConvertible {
    var description: String {
        return array.reduce(into: "") { result, i in
            result += String(i)
        }
    }
}

extension ConnectThreeGame: Equatable {}

// Test

typealias Computer = CarloTactician<ConnectThreeGame>

var computer = Computer(for: .two, maxRolloutDepth: 3)
var game = ConnectThreeGame(length: 10)

game = game.update(0) // player 1
game = game.update(8) // player 2
game = game.update(1) // player 1
computer.uproot(to: game)
for _ in 0..<50 {
    computer.iterate()
}
let move1 = computer.bestMove!
game = game.update(move1) // player 2
game = game.update(4) // player 1
computer.uproot(to: game)
for _ in 0..<100 {
    computer.iterate()
}
let move2 = computer.bestMove!
print(computer.root!.children)

