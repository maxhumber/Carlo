import Carlo
import Foundation

public struct TicTacToe: CarloGame, Equatable {
    public typealias Player = TicTacToePlayer
    public typealias Move = Int
    
    public var awaiting: Player
    public var board: [Player?] = .init(repeating: nil, count: 9)
    
    public init(starting player: Player = .x) {
        self.awaiting = player
    }

    public func availableMoves() -> [Move] {
        board.indices.filter { board[$0] == nil }
    }
    
    public func after(_ move: Move) throws -> Self {
        guard isValid(move) else { throw CarloError.invalidMove }
        let player = awaiting
        var game = self
        game.board[move] = player
        game.awaiting = player.opponent
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
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // <- Rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // <- Columns
        [0, 4, 8], [2, 4, 6]             // <- Diagonals
    ]
    
    private func all(matching player: Player, in indices: IndexSet) -> Bool {
        indices.map({ board[$0] }).allSatisfy({ $0 == player })
    }
}

