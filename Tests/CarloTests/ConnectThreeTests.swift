    import XCTest
    @testable import Carlo

    final class CarloTests: XCTestCase {

        func testFindOwnWinningMove() {
            typealias Computer = CarloTactician<ConnectThreeGame>
            let computer = Computer(for: .two, maxRolloutDepth: 5)
            var game = ConnectThreeGame(length: 10, currentPlayer: .one)
            game = game.update(4) // player 1
            game = game.update(0) // player 2
            game = game.update(7) // player 1
            game = game.update(2) // player 2
            game = game.update(9) // player 1
            // player 2 can win if move = 1
            computer.uproot(to: game)
            for _ in 0..<50 {
                computer.iterate()
            }
            let move = computer.bestMove!
            XCTAssertEqual(move, 1)
        }

        func testPreventOpponentsWinningMove() {
            typealias Computer = CarloTactician<ConnectThreeGame>
            let computer = Computer(for: .two, maxRolloutDepth: 5)
            var game = ConnectThreeGame(length: 10, currentPlayer: .one)
            game = game.update(4) // player 1
            game = game.update(0) // player 2
            game = game.update(7) // player 1
            game = game.update(2) // player 2
            // player 2 could win next move, if move = 1. So player 1 needs to prevent that.
            computer.uproot(to: game)
            for _ in 0..<250 {
                computer.iterate()
            }
            let move = computer.bestMove!
            XCTAssertEqual(move, 1)
        }
    }
