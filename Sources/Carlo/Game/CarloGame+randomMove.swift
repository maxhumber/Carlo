import Foundation

extension CarloGame {
    func randomMove() -> Move? {
        availableMoves().randomElement()
    }
}
