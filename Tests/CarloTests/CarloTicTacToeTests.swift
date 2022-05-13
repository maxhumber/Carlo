import XCTest
@testable import Carlo

final class CarloTicTacToeTests: XCTestCase {
    func testStartingBoard() {
        let game = CarloTicTacToe()
        XCTAssertEqual(game.board, [nil, nil, nil, nil, nil, nil, nil, nil, nil])
    }
    
    func testInvalidOutsideMove() {
        let game = CarloTicTacToe()
        XCTAssertThrowsError(try game.after(-1)) { error in
            XCTAssertEqual(error as! CarloError, .invalidMove)
        }
    }
    
    func testValidOpeningMove() {
        var game = CarloTicTacToe(starting: .x)
        game = try! game.after(4)
        XCTAssertEqual(game.board, [nil, nil, nil, nil, .x, nil, nil, nil, nil])
    }
    
    func testInvalidDoubleMove() {
        var game = CarloTicTacToe(starting: .x)
        game = try! game.after(0)
        XCTAssertThrowsError(try game.after(0)) { error in
            XCTAssertEqual(error as! CarloError, .invalidMove)
        }
    }
    
    func testAwaitingAtStart() {
        let game = CarloTicTacToe(starting: .x)
        XCTAssertEqual(game.awaiting, .x)
    }
    
    func testAwaitingAfterMove() {
        var game = CarloTicTacToe(starting: .x)
        game = try! game.after(0)
        XCTAssertEqual(game.awaiting, .o)
    }

    func testBoardCustomStringRepresentible() {
        var game = CarloTicTacToe(starting: .x)
        game = try! game.after(0) // X
        game = try! game.after(1) // O
        game = try! game.after(3) // X
        game = try! game.after(8) // O
        XCTAssertEqual("\(game)", "XO*\nX**\n**O")
    }
    
    func testAvailableMoves() {
        var game = CarloTicTacToe(starting: .x)
        game = try! game.after(0) // X
        game = try! game.after(1) // O
        game = try! game.after(3) // X
        game = try! game.after(8) // O
        let moves = game.availableMoves()
        let expected = [2, 4, 5, 6, 7]
        XCTAssertEqual(moves, expected)
    }
    
    func testIsInProgressTrue() {
        var game = CarloTicTacToe(starting: .x)
        game = try! game.after(0) // X
        game = try! game.after(8) // O
        game = try! game.after(1) // X
        game = try! game.after(7) // O
        XCTAssertTrue(game.isInProgress())
    }
    
    func testIsInProgressFalse() {
        var game = CarloTicTacToe(starting: .x)
        game = try! game.after(0) // X
        game = try! game.after(8) // O
        game = try! game.after(1) // X
        game = try! game.after(7) // O
        game = try! game.after(2) // X
        XCTAssertFalse(game.isInProgress())
    }
    
    func testWinForX() {
        var game = CarloTicTacToe(starting: .x)
        game = try! game.after(0) // X
        game = try! game.after(8) // O
        game = try! game.after(1) // X
        game = try! game.after(7) // O
        game = try! game.after(2) // X
        let payoff = game.evaluate(for: .x)
        XCTAssertEqual(payoff, .win)
    }
    
    func testLossForO() {
        var game = CarloTicTacToe(starting: .x)
        game = try! game.after(0) // X
        game = try! game.after(8) // O
        game = try! game.after(1) // X
        game = try! game.after(7) // O
        game = try! game.after(2) // X
        let payoff = game.evaluate(for: .o)
        XCTAssertEqual(payoff, .loss)
    }
    
    func testDraw() {
        var game = CarloTicTacToe(starting: .x)
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
}
