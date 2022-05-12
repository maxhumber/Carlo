import Carlo

struct ConnectThreeGame: CarloGame, CustomStringConvertible, Equatable {
    typealias Player = ConnectThreePlayer
    typealias Move = ConnectThreeMove

    var array: Array<Int>
    var player: Player
    
    init(length: Int = 10, startingPlayer: Player = .one) {
        self.array = Array.init(repeating: 0, count: length)
        self.player = startingPlayer
    }

    func availableMoves() -> [Move] {
        array
            .enumerated()
            .compactMap { $0.element == 0 ? Move($0.offset) : nil}
    }
    
    func after(_ move: Move) -> Self {
        var copy = self
        copy.array[move] = player.rawValue
        copy.player = player.opposite
        return copy
    }
    
    func payoff(for player: Player) -> CarloPayoff {
        let player3 = three(for: player)
        let oppo3 = three(for: player.opposite)
        let remaining0 = array.contains(0)
        switch (player3, oppo3, remaining0) {
        case (true, true, _): return .draw
        case (true, false, _): return .win
        case (false, true, _): return .loss
        case (false, false, false): return .draw
        default: return .score(0.5)
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

enum ConnectThreePlayer: Int, CustomStringConvertible {
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
