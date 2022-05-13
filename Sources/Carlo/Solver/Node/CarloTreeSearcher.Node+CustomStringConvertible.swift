import Foundation

extension CarloTreeSearcher.Node: CustomStringConvertible {
    var description: String {
        var str = awaitingExpansion ? "◻︎ " : "☑︎ "
        if let move = move {
            str += "\(move)"
        } else {
            str += "*"
        }
        str += " (\(totalValue)/\(visits))"
        return str
    }
}
