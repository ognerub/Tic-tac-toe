//
//  Tic_tac_toeApp.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 04.02.2026.
//

import SwiftUI
import SwiftData

@MainActor
final class AppContainer {

    let modelContainer: ModelContainer
    let swiftDataManager: SwiftDataManager

    init() {
        let schema = Schema([User.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        guard let container = try? ModelContainer(for: schema, configurations: [config]) else {
            fatalError("Failure to create a ModelContainer")
        }
        self.modelContainer = container
        self.swiftDataManager = SwiftDataManager(container: container)
    }
}


@main
struct Tic_tac_toeApp: App {

    private let appContainer = AppContainer()

    var body: some Scene {
        WindowGroup {
            TicTacToeView(appContainer)
        }
    }
}
