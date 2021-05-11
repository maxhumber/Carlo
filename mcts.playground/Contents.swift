import Foundation

// Required Structs








// Monte Carlo Tree Search Implementation



// Test CarloGame



// Test

typealias Computer = CarloTactician<ConnectThreeGame>

var computer = Computer(for: .two, maxRolloutDepth: 3)
var game = ConnectThreeGame(length: 10)

game = game.update(0) // player 1
game = game.update(8) // player 2
game = game.update(1) // player 1
computer.uproot(to: game)
for _ in 0..<50 {
    computer.iterate()
}
let move1 = computer.bestMove!
game = game.update(move1) // player 2
game = game.update(4) // player 1
computer.uproot(to: game)
for _ in 0..<100 {
    computer.iterate()
}
let move2 = computer.bestMove!
print(computer.root!.children)

