//
//  AlertTitle.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//


import SwiftUI

enum AlertTitle: LocalizedStringKey {
    case squareIsAlreadySelected = "This square is already selected"
    case draw = "It's a draw"
    case youWin = "You win! Well done!"
    case youLoose = "You loose, i will be the first now :)"
    case unknown = "Unknown error"
    case tabBlocked = "Score cards blocked while Tic-tac-toe is in progress, please end current game and try again"
}
