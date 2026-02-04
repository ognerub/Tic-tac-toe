//
//  TicTacToeViewModel.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 04.02.2026.
//


import Foundation
import Combine

@MainActor
final class TicTacToeViewModel: ObservableObject {

    @Published private(set) var humanMoves: Set<Int> = []
    @Published private(set) var computerMoves: Set<Int> = []
    @Published var alert: AlertTitle?

    private let engine = TicTacToeEngine()

    func tap(square: Int) {
        guard !humanMoves.contains(square),
              !computerMoves.contains(square)
        else {
            alert = .squareIsAlreadySelected
            return
        }

        humanMoves.insert(square)
        resolveGame(afterHumanMove: true)
    }

    private func resolveGame(afterHumanMove: Bool) {
        switch engine.gameResult(human: humanMoves, computer: computerMoves) {
        case .win(.human):
            alert = .youWin
        case .draw:
            alert = .draw
        case .ongoing:
            guard afterHumanMove,
                  let move = engine.computerMove(
                    human: humanMoves,
                    computer: computerMoves
                  )
            else { return }

            computerMoves.insert(move)
            resolveGame(afterHumanMove: false)

        case .win(.computer):
            alert = .youLoose
        }
    }

    func reset(computerStarts: Bool = false) {
        humanMoves = []
        computerMoves = []

        if computerStarts {
            computerMoves.insert(Int.random(in: 0...8))
        }
    }
}
