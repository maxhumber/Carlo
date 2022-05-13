import XCTest
@testable import Carlo
@testable import TicTacToe

class CarloSolverTests: XCTestCase {
    typealias Game = TicTacToe
    typealias Solver = CarloTree<Game>
    typealias Node = Solver.Node

    var game: Game!
    var solver: Solver!

    override func setUp() {
        solver = Solver(.o)
        game = Game(starting: .x)
        game = try! game.after(0) // X
        game = try! game.after(1) // O
        game = try! game.after(2) // X
        solver.root = Node(game: game)
    }

    func testRandomPlayouts() {
        let playouts = (0..<20).map { _ in solver.root!.randomPlayout() }
        let allDifferent = !playouts.dropLast().allSatisfy { $0 == playouts.last }
        XCTAssertTrue(allDifferent)
    }
    
    func testPrint() {
        print(solver.root!)
        try! solver.root!.expand()
        print(solver.root!)
        print(solver.root!.children)
    }
    
//    func testSolverRandomPlayoutValues() throws {
//        let playouts = (0..<20).map { _ in solver.randomPlayout(game) }
//        let values = playouts.map { solver.evaluate(playout: $0) }
//        let allDifferent = !values.dropLast().allSatisfy { $0 == values.last }
//        XCTAssertTrue(allDifferent)
//    }

}
