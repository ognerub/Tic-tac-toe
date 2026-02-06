//
//  BackendAuthErrorResponse.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 06.02.2026.
//


import Foundation

struct BackendAuthErrorResponse: Decodable, Error {
    let message: [String]
    let error: String
    let statusCode: Int
}
