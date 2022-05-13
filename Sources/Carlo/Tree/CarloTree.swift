import Foundation

public final class CarloTree<Game: CarloGame> {
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
        let leaf = root.selectLeaf()
        try! leaf.expand()
        let child = leaf.randomChild()! // << hmmm
        let game = child.randomPlayout(maxTurns: maxPlayoutTurns)
        let payoff = game.evaluate(for: player)
        let value = payoff.value
        child.backpropagate(value: value)
    }
}
