import Foundation

extension CarloGame {
    func isInProgress() -> Bool {
        switch evaluate(for: awaiting) {
        case .score: return true
        default: return false
        }
    }
    
    func randomMove() -> Move? {
        availableMoves().randomElement()
    }
}
