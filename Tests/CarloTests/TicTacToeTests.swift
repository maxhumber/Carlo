import XCTest
@testable import Carlo

final class TicTacToeTests: XCTestCase {
    var game: TicTacToe!
    
    override func setUp() {
        game = TicTacToe(starting: .x)
        game = try! game.after(0) // X
        game = try! game.after(1) // O
        game = try! game.after(2) // X
        game = try! game.after(4) // O
        game = try! game.after(3) // X
        game = try! game.after(5) // O
    }
    
    func testBoardCustomStringRepresentible() {
        XCTAssertEqual("\(game!)", "XOX\nXOO\n*X*")
    }
    
    func testIsInProgressTrue() {
        XCTAssertTrue(game.isInProgress())
    }
    
    func testAwaiting() {
        XCTAssertEqual(game.awaiting, .x)
    }
    
    func testAvailableMoves() {
        let moves = game.availableMoves()
        let expected = [6, 8]
        XCTAssertEqual(moves, expected)
    }

    func testInvalidOutsideMove() {
        XCTAssertThrowsError(try game.after(-1)) { error in
            XCTAssertEqual(error as! CarloError, .invalidMove)
        }
    }
    
    func testInvalidDoubleMove() {
        XCTAssertThrowsError(try game.after(0)) { error in
            XCTAssertEqual(error as! CarloError, .invalidMove)
        }
    }
    
    func testWinForX() {
        var game = TicTacToe(starting: .x)
        game = try! game.after(0) // X
        game = try! game.after(8) // O
        game = try! game.after(1) // X
        game = try! game.after(7) // O
        game = try! game.after(2) // X
        let payoff = game.evaluate(for: .x)
        XCTAssertEqual(payoff, .win)
    }
    
    func testLossForO() {
        var game = TicTacToe(starting: .x)
        game = try! game.after(0) // X
        game = try! game.after(8) // O
        game = try! game.after(1) // X
        game = try! game.after(7) // O
        game = try! game.after(2) // X
        let payoff = game.evaluate(for: .o)
        XCTAssertEqual(payoff, .loss)
    }
    
    func testDraw() {
        var game = TicTacToe(starting: .x)
        game = try! game.after(0) // X
        game = try! game.after(1) // O
        game = try! game.after(2) // X
        game = try! game.after(4) // O
        game = try! game.after(3) // X
        game = try! game.after(5) // O
        game = try! game.after(7) // X
        game = try! game.after(6) // O
        game = try! game.after(8) // X
        let payoff = game.evaluate(for: .x)
        XCTAssertEqual(payoff, .draw)
    }
    
    func testIsInProgressFalse() {
        var game = TicTacToe(starting: .x)
        game = try! game.after(0) // X
        game = try! game.after(8) // O
        game = try! game.after(1) // X
        game = try! game.after(7) // O
        game = try! game.after(2) // X
        XCTAssertFalse(game.isInProgress())
    }
}
