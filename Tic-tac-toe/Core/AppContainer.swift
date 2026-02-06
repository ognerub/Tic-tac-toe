//
//  AppContainer.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 06.02.2026.
//


import SwiftUI
import SwiftData

@MainActor
final class AppContainer {

    let modelContainer: ModelContainer
    let swiftDataManager: SwiftDataManagerProtocol
    let networkManager: NetworkManagerProtocol
    let apiClient: APIClientProtocol

    init() {
        let schema = Schema([User.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        guard let container = try? ModelContainer(for: schema, configurations: [config]) else {
            fatalError("Failure to create a ModelContainer")
        }
        self.modelContainer = container
        self.swiftDataManager = SwiftDataManager(container: container)
        self.apiClient = APIClient()
        self.networkManager = NetworkManager(apiClient)
    }
}
