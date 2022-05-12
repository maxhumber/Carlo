    import XCTest
    @testable import Carlo

    final class CarloTests: XCTestCase {
        func testFindOwnWinningMove() async {
            typealias Solver = CarloSolver<ConnectThreeGame>
            let solver = Solver(.two, maxRolloutDepth: 5)
            var game = ConnectThreeGame(length: 10, startingPlayer: .one)
            game = game.after(4) // player 1
            game = game.after(0) // player 2
            game = game.after(7) // player 1
            game = game.after(2) // player 2
            game = game.after(9) // player 1
            // player 2 can win if move = 1
            solver.pickup(to: game)
            for _ in 0..<50 {
                solver.search()
                print(solver.bestNode)
            }
            let move = solver.bestMove!
            XCTAssertEqual(move, 1)
        }

        func testPreventOpponentsWinningMove() async {
            typealias Computer = CarloSolver<ConnectThreeGame>
            let computer = Computer(.two, maxRolloutDepth: 5)
            var game = ConnectThreeGame(length: 10, startingPlayer: .one)
            game = game.after(4) // player 1
            game = game.after(0) // player 2
            game = game.after(7) // player 1
            game = game.after(2) // player 2
            // player 2 could win next move, if move = 1. So player 1 needs to prevent that.
            computer.pickup(to: game)
            for _ in 0..<250 {
                computer.search()
            }
            let move = computer.bestMove!
            XCTAssertEqual(move, 1)
        }
    }
