//
//  APIClientProtocol.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 06.02.2026.
//


import Foundation

// MARK: - APIClientProtocol
protocol APIClientProtocol: Sendable {
    var decoder: JSONDecoder { get }
    var encoder: JSONEncoder { get }
    func requestBuilder<T: Encodable>(
        path: String,
        queryItems: [URLQueryItem],
        method: NetworkMethods,
        headers: [String: String],
        authorization: NetworkAuthorizationType,
        body: T?
    ) -> URLRequest?
    func makeSimpleRequest(_ urlRequest: URLRequest) async throws
    func makeDecodableRequest<T: Decodable>(_ urlRequest: URLRequest) async throws -> T
}

extension APIClientProtocol {
    // MARK: - Request builder
    func requestBuilder<T: Encodable>(
        path: String,
        queryItems: [URLQueryItem] = [],
        method: NetworkMethods,
        headers: [String: String] = [NetworkHeaders.contentType: NetworkHeadersValues.applicationJson],
        authorization: NetworkAuthorizationType = .none,
        body: T? = nil as String?
    ) -> URLRequest? {
        guard let url = URL(string: path) else {
            assertionFailure("Failed to build request from \(path)")
            return nil
        }
        let queriedUrl = url.appending(queryItems: queryItems)
        var request = URLRequest(url: queriedUrl)
        request.httpMethod = method.rawValue
        for header in headers {
            request.setValue(
                header.value,
                forHTTPHeaderField: header.key
            )
        }
        request.timeoutInterval = 30.0
        switch authorization {
        case .accessToken:
            let accessToken = "" // could be taken from token storage if needed
            request.setValue("\(NetworkConstants.bearerPrefix)\(accessToken)", forHTTPHeaderField: NetworkHeaders.authorization)
        case .refreshToken:
            let refreshToken = "" // could be taken from token storage if needed
            request.setValue("\(NetworkConstants.bearerPrefix)\(refreshToken)", forHTTPHeaderField: NetworkHeaders.authorization)
        case .none:
            break
        }
        if method == .post || method == .put {
            if let body, let data = try? encoder.encode(body) {
                request.httpBody = data
            }
        }
        return request
    }

    // MARK: - Simple request
    func makeSimpleRequest(
        _ urlRequest: URLRequest
    ) async throws {
        let _ = try await makeRequestHelper(urlRequest)
    }

    // MARK: - Decodable request
    func makeDecodableRequest<T: Decodable>(
        _ urlRequest: URLRequest
    ) async throws -> T {
        let data = try await makeRequestHelper(urlRequest)
        return try decoder.decode(T.self, from: data)
    }
}

// MARK: - APIClientProtocol Helpers
private extension APIClientProtocol {

    func makeRequestHelper(_ urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        switch httpResponse.statusCode {
        case 200, 201, 204:
            return data
        case 401:
            // Clear tokens is needed
            throw APIError(statusCode: 401, message: "Unauthorized")
        default:
            throw decodeAPIError(
                data: data,
                statusCode: httpResponse.statusCode
            )
        }
    }

    func decodeAPIError(
        data: Data,
        statusCode: Int
    ) -> Error {
        if let backendError = try? decoder.decode(
            BackendAuthErrorResponse.self,
            from: data
        ) {
            return backendError
        }
        return APIError(
            statusCode: statusCode,
            message: HTTPURLResponse.localizedString(forStatusCode: statusCode)
        )
    }
}

// MARK: - APIClient
final class APIClient: APIClientProtocol {

    let decoder: JSONDecoder
    let encoder: JSONEncoder

    init() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [
                .withInternetDateTime,
                .withFractionalSeconds
            ]
            if let date = formatter.date(from: string) {
                return date
            }
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid ISO8601 date: \(string)"
            )
        }
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [
                .withInternetDateTime,
                .withFractionalSeconds
            ]
            try container.encode(formatter.string(from: date))
        }
    }
}

