//
//  SwiftDataManager.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//

import Foundation
import SwiftData

protocol SwiftDataManagerProtocol {
    func fetchUsers() async -> [User]
    func insert(user: User)
    func delete(user: User)
    func save()
}

@MainActor
final class SwiftDataManager: SwiftDataManagerProtocol {

    private let context: ModelContext

    init(container: ModelContainer) {
        self.context = ModelContext(container)
    }

    // MARK: - Fetch

    func fetchUsers() async -> [User] {
        let descriptor = FetchDescriptor<User>(
            sortBy: [
                SortDescriptor(\.gamesWonInARow, order: .reverse),
                SortDescriptor(\.totalInGameTime, order: .forward),
                SortDescriptor(\.name, order: .forward)
            ]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func insert(user: User) {
        context.insert(user)
    }

    func delete(user: User) {
        context.delete(user)
    }

    func save() {
        try? context.save()
    }
}

