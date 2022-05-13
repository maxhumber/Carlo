import Foundation

extension CarloTree.Node: CustomStringConvertible {
    var description: String {
        var str = isLeaf ? "◻︎ " : "☑︎ "
        if let move = move {
            str += "\(move)"
        } else {
            str += "*"
        }
        str += " (\(totalValue)/\(visits))"
        return str
    }
}
