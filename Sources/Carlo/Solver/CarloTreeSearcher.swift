import Foundation

public final class CarloTreeSearcher<Game: CarloGame> {
    public typealias Player = Game.Player
    public typealias Move = Game.Move

    let player: Player
    let maxPlayoutTurns: Int
    let explorationConstant: Double
    var root: Node!
    
    public init(_ player: Player, maxPlayoutTurns: Int = .max, explorationConstant: Double = sqrt(2)) {
        self.player = player
        self.maxPlayoutTurns = maxPlayoutTurns
        self.explorationConstant = explorationConstant
    }
    
    func search() {
        let leaf = root.randomSelect()
        try! leaf.expand()
        let newLeaf = leaf.children.randomElement()
        let game = newLeaf.randomPlayout(maxTurns: maxPlayoutTurns)
        let payoff = game?.evaluate(for: player)
        let value = payoff?.value
        newLeaf?.backpropagate(value: value)
    }
}
