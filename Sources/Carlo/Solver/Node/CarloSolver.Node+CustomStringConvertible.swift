import Foundation

extension CarloSolver.Node: CustomStringConvertible {
    var description: String {
        let percent = cumulativeValue/Double(visits) * 100
        return "\(cumulativeValue)/\(visits) (\(String(format: "%.0f", percent))%)"
    }
}
