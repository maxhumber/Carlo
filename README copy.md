<h3 align="center">
  <img src="https://raw.githubusercontent.com/maxhumber/Carlo/master/images/Carlo.png" height="300px" alt="Carlo">
</h3>


### Carlo

Carlo is a *Monte Carlo Tree Search* (MCTS) library for turn-based games. Whereas [GKMonteCarloStrategist](https://developer.apple.com/documentation/gameplaykit/gkmontecarlostrategist) is clunky and confusing, Carlo is simple and easy to use!



### Import

Import Carlo by adding the following line to any `.swift` file:

```swift
import Carlo
```



### Implement

Implement Carlo by designing **player**, **move**, and **game** structs that conform to the `CarloGamePlayer`, `CarloGameMove`, and `CarloGame` protocols. 

While the first two protocols don't explicitly require anything, "conforming" to them might look like this: 

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

Conforming to `CarloGame` requires the following: 

```swift
public protocol CarloGame: Equatable {
    associatedtype Player: CarloGamePlayer
    associatedtype Move: CarloGameMove
  
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



### Use

Use Carlo by scaffolding a `CarloTactician` on a `CarloGame`:

```swift
typealias Computer = CarloTactician<ConnectThreeGame>
```

Instantiate with arguments for `CarloGamePlayer` and a limit for the number turns to rollout in a single search iteration:

```swift
let computer = Computer(for: .two, maxRolloutDepth: 5)
```

Call the `.iterate()` method to perform one search iteration in the tree, `.bestMove` to get the best move (so far) as found by search algorithm, and `.uproot(to:)` to recycle the tree and update the internal game state:

```swift
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



### Install

If you use [Swift Package Manager](https://swift.org/package-manager/) adding Carlo as a dependency is as easy as adding it to the `dependencies` of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/maxhumber/Carlo.git", from: "1.0.2")
]
```
