//
//  AlertTitle.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//


import SwiftUI

enum AlertTitle: Equatable {
    
    static func == (lhs: AlertTitle, rhs: AlertTitle) -> Bool {
        switch (lhs, rhs) {
        case (.squareIsAlreadySelected, .squareIsAlreadySelected),
             (.draw, .draw),
             (.youWin, .youWin),
             (.youLose, .youLose),
             (.unknown, .unknown),
             (.tabBlocked, .tabBlocked):
            return true

        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription

        default:
            return false
        }
    }

    case squareIsAlreadySelected
    case draw
    case youWin
    case youLose
    case unknown
    case tabBlocked
    case successSending
    case error(Error)

    var localized: LocalizedStringResource {
        switch self {
        case .squareIsAlreadySelected:
            return "This square is already selected"
        case .draw:
            return "It's a draw"
        case .youWin:
            return "You win! Well done!"
        case .youLose:
            return "You lose, I will be the first now"
        case .unknown:
            return "Unknown error"
        case .tabBlocked:
            return "Action blocked while Tic-tac-toe is in progress, please end current game and try again"
        case .successSending:
            return "User data successfully sent"
        case .error(let error):
            return "\(error.localizedDescription)"
        }
    }
}
