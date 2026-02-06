//
//  Mocks.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//


import Foundation

enum Mocks {
    static let appContainer = AppContainer()
    static let appSettings = AppSetting()
    static let viewModel = TicTacToeViewModel(appContainer)

    static let users: [User] = [
        User("Alex", "figure", totalGamesCount: 3, gamesWonByHuman: 1, gamesWonInARow: 1, totalInGameTime: 19.24),
        User("Oleg", "figure.rower", totalGamesCount: 3, gamesWonByHuman: 2, gamesWonInARow: 2, totalInGameTime: 12.24),
        User("Michael", "figure.run", totalGamesCount: 3, gamesWonByHuman: 2, gamesWonInARow: 2, totalInGameTime: 1.24),
        User("Anton", "figure.american.football", totalGamesCount: 5, gamesWonByHuman: 3, drawGamesCount: 1, gamesWonInARow: 3, totalInGameTime: 24.24),
        User("Andrey", "figure.archery", totalGamesCount: 3, gamesWonInARow: 0, totalInGameTime: 17.24),
        User("Alexey", "figure.boxing"),
        User("Dmitriy", "figure.cricket"),
        User("Nikolay", "figure.dance"),
        User("Igor", "figure.fishing"),
        User("Ivan", "figure.golf"),
        User("Olga", "figure.handball"),
        User("Tatiana", "figure.hiking"),
        User("Anastasia", "figure.hockey"),
        User("Elena", "figure.outdoor.cycle"),
        User("Maria", "figure.snowboarding"),
        User("Irina", "figure.tennis"),
        User("Anna", "figure.strengthtraining.traditional"),
        User("Elizaveta", "figure.surfing")
    ]

    static let userImages: [String] = [
        "figure",
        "figure.rower",
        "figure.run",
        "figure.american.football",
        "figure.archery",
        "figure.boxing",
        "figure.cricket",
        "figure.dance",
        "figure.fishing",
        "figure.golf",
        "figure.handball",
        "figure.hiking",
        "figure.hockey",
        "figure.outdoor.cycle",
        "figure.snowboarding",
        "figure.tennis",
        "figure.strengthtraining.traditional",
        "figure.surfing",
        "figure.stair.stepper",
        "figure.ice.skating",
        "figure.pool.swim",
        "figure.play"
    ]
}
