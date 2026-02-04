//
//  TicTacToeEngine.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 04.02.2026.
//


import Foundation

struct TicTacToeEngine {

    let allSquares: Set<Int> = Set(0...8)

    let winPatterns: Set<Set<Int>> = [
        [0,1,2], [3,4,5], [6,7,8],
        [0,4,8], [2,4,6],
        [0,3,6], [1,4,7], [2,5,8]
    ]

    func winner(for moves: Set<Int>) -> Bool {
        guard moves.count >= 3 else { return false }
        return winPatterns.contains { $0.isSubset(of: moves) }
    }

    func freeSquares(human: Set<Int>, computer: Set<Int>) -> Set<Int> {
        allSquares.subtracting(human.union(computer))
    }

    func gameResult(human: Set<Int>, computer: Set<Int>) -> GameResult {
        if winner(for: human) { return .win(.human) }
        if winner(for: computer) { return .win(.computer) }
        if freeSquares(human: human, computer: computer).isEmpty {
            return .draw
        }
        return .ongoing
    }
}

extension TicTacToeEngine {

    func computerMove(human: Set<Int>, computer: Set<Int>) -> Int? {
        // 1. Try to win
        if let win = finishingMove(for: computer, blocking: human) {
            return win
        }
        // 2. Block human
        if let block = finishingMove(for: human, blocking: computer) {
            return block
        }
        // 3. Take any free square
        return freeSquares(human: human, computer: computer).randomElement()
    }

    private func finishingMove(for player: Set<Int>, blocking opponent: Set<Int>) -> Int? {
        for pattern in winPatterns {
            let intersection = pattern.intersection(player)
            if intersection.count == 2 {
                let missing = pattern.subtracting(player)
                if let square = missing.first, !opponent.contains(square) {
                    return square
                }
            }
        }
        return nil
    }
}

