//
//  NetworkConstants.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 06.02.2026.
//


import Foundation

enum NetworkMethods: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkAuthorizationType {
    case accessToken
    case refreshToken
    case none
}

enum NetworkHeaders {
    static let contentType = "Content-Type"
    static let authorization = "Authorization"
}

enum NetworkHeadersValues {
    static let applicationJson = "application/json"
}

enum NetworkEndpoints {
    static let users = "users"
}

enum NetworkConstants {
    static let baseUrl = "https://example-api.com/" // TODO: - replace with real server if needed
    static let bearerPrefix = "Bearer "
}
