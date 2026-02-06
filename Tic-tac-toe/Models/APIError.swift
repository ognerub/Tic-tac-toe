//
//  APIError.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 06.02.2026.
//


import Foundation

struct APIError: Error, LocalizedError {
    let statusCode: Int
    let message: String

    var errorDescription: String? {
        message
    }
}
