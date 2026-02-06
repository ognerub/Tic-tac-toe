//
//  NetworkManager.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 06.02.2026.
//


import Foundation

protocol NetworkManagerProtocol {
    func sendData(_ users: [User]) async throws
}

actor NetworkManager: NetworkManagerProtocol {

    private let apiClient: APIClientProtocol

    init(_ apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func sendData(_ users: [User]) async throws {
        try await sendDataExampleRequest(users)
    }

    private func sendDataExampleRequest(_ users: [User]) async throws {
        let usersCodable = users.map { $0.mapToCodable() }
        let request = await apiClient.requestBuilder(
            path: "\(NetworkConstants.baseUrl)\(NetworkEndpoints.users)",
            method: .post,
            authorization: .none,
            body: usersCodable
        )
        guard let request else {
            throw URLError(.badURL)
        }
        _ = try await apiClient.makeSimpleRequest(request)
    }
}
