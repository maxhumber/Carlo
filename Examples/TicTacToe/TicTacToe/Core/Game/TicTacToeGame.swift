import Carlo
import Foundation

struct TicTacToeGame: CarloGame {
    typealias Move = Int
    typealias Player = TicTacToePlayer
    
    var player: Player
    var board: [Player?] = .init(repeating: nil, count: 9)
    
    init(starting player: Player = .x) {
        self.player = player
    }

    func availableMoves() -> [Move] {
        board.indices.filter { board[$0] != nil }
    }
    
    func after(_ move: Move) -> Self {
        var game = self
        game.board[move] = player
        game.player = player.opponent
        return game
    }
    
    func payoff(for player: Player) -> CarloPayoff {
        for line in lines {
            if all(matching: player, at: line) { return .win }
            if all(matching: player.opponent, at: line) { return .loss }
        }
        if board.allSatisfy({ $0 != nil }) { return .draw }
        return .score(0.5)
    }
    
    private let lines: [IndexSet] = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
        [0, 4, 8], [2, 4, 6]             // diagonals
    ]
    
    private func all(matching player: Player, at indices: IndexSet) -> Bool {
        indices
            .map { board[$0] }
            .allSatisfy { $0 == player }
    }
}

