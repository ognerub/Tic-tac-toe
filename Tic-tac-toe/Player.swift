//
//  Player.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 04.02.2026.
//


import Foundation

enum Player {
    case human
    case computer
}

enum GameResult {
    case ongoing
    case draw
    case win(Player)
}
