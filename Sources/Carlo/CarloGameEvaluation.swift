//
//  CarloGameEvaluation.swift
//  Created by max on 2021-05-11.
//

import Foundation

/// Game state evaluation
public enum CarloGameEvaluation {
    /// Evaluate to a win
    case win
    /// Evaluate to a loss
    case loss
    /// Evaluate to a draw
    case draw
    /// Evaluate to a game in progress, with an associated probability of winning (bound between 0 and 1)
    case ongoing(Double)
    
    /// The corresponding value of the evaluation
    ///
    /// - returns: a `Double` bound by `0` and `1`
    public var value: Double {
        switch self {
        case .win: return 1
        case .loss: return 0
        case .draw: return 0.5
        case .ongoing(let ongoingValue): return ongoingValue
        }
    }
}
