//
//  User.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//

import Foundation
import SwiftData

@Model
final class User {
    var id: UUID
    var name: String
    var iconName: String?
    var createdAt: Date
    // MARK: - Game stats
    var totalGamesCount: Int
    var gamesWonByHuman: Int
    var drawGamesCount: Int
    var gamesWonInARow: Int
    var totalInGameTime: Double

    // MARK: - Init for a new user
    init(_ name: String, _ iconName: String? = nil) {
        self.id = UUID()
        self.name = name
        self.iconName = iconName
        self.createdAt = Date()
        self.totalGamesCount = 0
        self.gamesWonByHuman = 0
        self.drawGamesCount = 0
        self.gamesWonInARow = 0
        self.totalInGameTime = 0.0
    }
}


