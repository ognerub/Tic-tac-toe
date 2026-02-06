//
//  User.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//

import Foundation
import SwiftData

@Model
final class User: Identifiable, @unchecked Sendable {
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

    // MARK: - Init
    init(
        _ name: String,
        _ iconName: String? = nil,
        totalGamesCount: Int = 0,
        gamesWonByHuman: Int = 0,
        drawGamesCount: Int = 0,
        gamesWonInARow: Int = 0,
        totalInGameTime: Double = 0.0
    ) {
        self.id = UUID()
        self.name = name
        self.iconName = iconName
        self.createdAt = Date()
        self.totalGamesCount = totalGamesCount
        self.gamesWonByHuman = gamesWonByHuman
        self.drawGamesCount = drawGamesCount
        self.gamesWonInARow = gamesWonInARow
        self.totalInGameTime = totalInGameTime
    }

    func mapToCodable() -> UserCodable {
        .init(
            id: id,
            name: name,
            iconName: iconName,
            createdAt: createdAt,
            totalGamesCount: totalGamesCount,
            gamesWonByHuman: gamesWonByHuman,
            drawGamesCount: drawGamesCount,
            gamesWonInARow: gamesWonInARow,
            totalInGameTime: totalInGameTime
        )
    }
}

struct UserCodable: Codable {
    let id: UUID
    let name: String
    let iconName: String?
    let createdAt: Date
    let totalGamesCount: Int
    let gamesWonByHuman: Int
    let drawGamesCount: Int
    let gamesWonInARow: Int
    let totalInGameTime: Double
}


