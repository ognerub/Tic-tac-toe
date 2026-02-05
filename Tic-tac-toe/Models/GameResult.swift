//
//  GameResult.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//


import Foundation

enum GameResult: Equatable {
    case ongoing
    case draw
    case win(PlayerType)
}
