<h3 align="center">
  <img src="https://raw.githubusercontent.com/maxhumber/Carlo/master/images/Carlo.png" height="300px" alt="Carlo">
</h3>


### Carlo

Carlo is a *Monte Carlo Tree Search* (MCTS) library for turn-based games. Whereas [GKMonteCarloStrategist](https://developer.apple.com/documentation/gameplaykit/gkmontecarlostrategist) is clunky, confusing, and old, Carlo is simple, easy to use, and highly flexible!



### Usage

Import Carlo into your project by adding the following line to any `.swift` file:

```swift
import Carlo
```

To implement Carlo, your **player**, **move**, and **game** structs need to adhere to the `CarloGamePlayer`, `CarloGameMove`, and `CarloGame` protocols. The first two protocols are empty so they can literally be anything:

```swift
enum ConnectThreePlayer: Int, CarloGamePlayer, CustomStringConvertible {
    case one = 1
    case two = 2
    
    var opposite: Self {
        switch self {
        case .one: return .two
        case .two: return .one
        }
    }
    
    var description: String {
        "\(rawValue)"
    }
}

typealias ConnectThreeMove = Int
extension ConnectThreeMove: CarloGameMove {}
```

The `CarloGame` protocol requires your game struct take the form:

```swift
public protocol CarloGame: Equatable {
    associatedtype Player: CarloGamePlayer
    associatedtype Move: CarloGameMove
    typealias Evaluation = CarloGameEvaluation
  
    var currentPlayer: Player { get }
    func availableMoves() -> [Move]
    func update(_ move: Move) -> Self
    func evaluate(for player: Player) -> Evaluation
}
```

Properly implemented it might look like this:

```swift
struct ConnectThreeGame: CarloGame, CustomStringConvertible, Equatable {
    typealias Player = ConnectThreePlayer
    typealias Move = ConnectThreeMove

    var array: Array<Int>
  
    // REQUIRED
    var currentPlayer: Player
    
    init(length: Int = 10, currentPlayer: Player = .one) {
        self.array = Array.init(repeating: 0, count: length)
        self.currentPlayer = currentPlayer
    }

    // REQUIRED
    func availableMoves() -> [Move] {
        array
            .enumerated()
            .compactMap { $0.element == 0 ? Move($0.offset) : nil}
    }
    
    // REQUIRED
    func update(_ move: Move) -> Self {
        var copy = self
        copy.array[move] = currentPlayer.rawValue
        copy.currentPlayer = currentPlayer.opposite
        return copy
    }
    
    // REQUIRED
    func evaluate(for player: Player) -> Evaluation {
        let player3 = three(for: player)
        let oppo3 = three(for: player.opposite)
        let remaining0 = array.contains(0)
        switch (player3, oppo3, remaining0) {
        case (true, true, _): return .draw
        case (true, false, _): return .win
        case (false, true, _): return .loss
        case (false, false, false): return .draw
        default: return .ongoing(0.5)
        }
    }
    
    private func three(for player: Player) -> Bool {
        var count = 0
        for slot in array {
            if slot == player.rawValue {
                count += 1
            } else {
                count = 0
            }
            if count == 3 {
                return true
            }
        }
        return false
    }
    
    var description: String {
        return array.reduce(into: "") { result, i in
            result += String(i)
        }
    }
}
```

Once the game is defined, a `CarloTactician` can be instantiated with ease:

```swift
typealias Computer = CarloTactician<ConnectThreeGame>
let computer = Computer(for: .two, maxRolloutDepth: 5)

var game = ConnectThreeGame(length: 10, currentPlayer: .one)
/// 0000000000
game = game.update(4)
/// 0000100000
game = game.update(0)
/// 2000100000
game = game.update(7)
/// 2000100000
game = game.update(2)
/// 2020100000
game = game.update(9)
/// 2020100001 ... player 2 can win if move => 1

computer.uproot(to: game)
for _ in 0..<50 {
    computer.iterate()
}

let move = computer.bestMove!
game = game.update(move)
/// 2220100001 ... game over
```

A few things to note:

- The `.uproot` method updates the internal game state tracked by the "Tactician"
- The `.iterate` method performs one search in the Tactician's "tree" (and should consequently be used in conjunction with a `for`/`while` loop as more iterations will lead to better moves)
- And the `.bestMove` property will return the best move (so far) found by the search algorithm



### Installation

If you use [Swift Package Manager](https://swift.org/package-manager/) adding Carlo as a dependency is as easy as adding it to the `dependencies` of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/maxhumber/Carlo.git", from: "1.0")
]
```
