import Foundation

public struct CarloTicTacToe: CarloGame {
    public typealias Player = CarloTicTacToePlayer
    public typealias Move = Int
    
    public var awaiting: Player?
    public var board: [Player?] = .init(repeating: nil, count: 9)
    
    public init(starting player: Player = .x) {
        self.awaiting = player
    }

    public func availableMoves() -> [Move] {
        board.indices.filter({ board[$0] == nil })
    }
    
    public func after(_ move: Move) throws -> Self {
        guard let player = awaiting else { throw CarloError.gameIsFinished }
        guard isValid(move) else { throw CarloError.invalidMove }
        var game = self
        game.board[move] = player
        let outcome = game.evaluate(for: player)
        switch outcome {
        case .score:
            game.awaiting = player.opponent
        default:
            game.awaiting = nil
        }
        return game
    }
    
    private func isValid(_ move: Move) -> Bool {
        board.indices.contains(move) && board[move] == nil
    }
    
    public func evaluate(for player: Player) -> CarloPayoff {
        for line in lines {
            if all(matching: player, in: line) { return .win }
            if all(matching: player.opponent, in: line) { return .loss }
        }
        if !board.contains(nil) { return .draw }
        return .score(0.5)
    }
    
    private let lines: [IndexSet] = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
        [0, 4, 8], [2, 4, 6]             // diagonals
    ]
    
    private func all(matching player: Player, in indices: IndexSet) -> Bool {
        indices.map({ board[$0] }).allSatisfy({ $0 == player })
    }
}

