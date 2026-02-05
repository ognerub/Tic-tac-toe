//
//  SwiftDataManager.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataManager {

    private let context: ModelContext

    init(container: ModelContainer) {
        self.context = ModelContext(container)
    }

    // MARK: - Fetch

    func fetchUsers() -> [User] {
        let descriptor = FetchDescriptor<User>(
            sortBy: [SortDescriptor(\.gamesWonInARow)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    // MARK: - Write

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

