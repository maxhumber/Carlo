import XCTest
@testable import TicTacToe

class TicTacToeTests: XCTestCase {
    func testBoardPrint() throws {
        var game = TicTacToeGame()
        game = game.after(0)
        game = game.after(1)
        game = game.after(3)
        game = game.after(8)
        print(game)
    }
}
