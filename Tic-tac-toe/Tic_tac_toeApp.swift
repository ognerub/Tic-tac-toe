//
//  Tic_tac_toeApp.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 04.02.2026.
//

import SwiftUI
import SwiftData

@main
struct Tic_tac_toeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
