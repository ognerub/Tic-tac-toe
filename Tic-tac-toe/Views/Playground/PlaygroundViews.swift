//
//  PlaygroundViews.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 06.02.2026.
//


import SwiftUI

extension PlaygroundView {
    func playground(_ geo: GeometryProxy) -> some View {
        ZStack {
            let squareSize = computeSquareSize(using: geo)
            playfield(squareSize)
            winLine(squareSize)
        }
    }

    func currentUserInfo(_ geo: GeometryProxy) -> some View {
        Group {
            if isPortrait(geo) {
                if let user = viewModel.selectedUser {
                    Text("Current user is \(user.name). Press to change.")
                } else {
                    Text("Please press here to select user first")
                }
            }
//            if let user = viewModel.selectedUser, isPortrait(geo) {
//                let attributedText: AttributedString = {
//                    let localized = LocalizedStringResource(
//                        "Current user is \(user.name). Press to change.",
//                        comment: "Text showing selected user"
//                    )
//                    var result = AttributedString(localized: localized)
//                    if let range = result.range(of: user.name) {
//                        result[range].underlineStyle = .single
//                    }
//                    return result
//                }()
//                Text(attributedText)
//            } else {
//                let attributedText: AttributedString = {
//                    let fullString = String(localized: "Please press here to select user first")
//                    let selectString = String(localized: "select")
//                    var result = AttributedString(fullString)
//                    if let range = result.range(of: selectString) {
//                        result[range].underlineStyle = .single
//                    }
//                    return result
//                }()
//                Text(attributedText)
//            }
        }
        .onTapGesture {
            guard viewModel.humanMoves.isEmpty || viewModel.computerMoves.isEmpty else {
                viewModel.showAlert(.tabBlocked)
                return
            }
            viewModel.isPlayerSelectionPresented = true
        }
    }

    @ViewBuilder
    func marker(at index: Int, squareSize: CGFloat) -> some View {
        switch markerType(at: index) {
        case .player:
            AnimatedXMarker(size: squareSize / 1.5)
        case .computer:
            AnimatedOMarker(size: squareSize / 1.5)
        case .none:
            EmptyView()
        }
    }

    func playfield(_ squareSize: CGFloat) -> some View {
        return LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible(), spacing: 10),
                count: 3
            ),
            spacing: 10
        ) {
            ForEach(0..<9, id: \.self) { index in
                square(at: index, size: squareSize)
            }
        }
        .frame(width: computePlayfieldWidth(using: squareSize))
    }

    func square(at index: Int, size: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1),
                        radius: 10,
                        x: 1,
                        y: 1)
            marker(at: index, squareSize: size)
        }
        .frame(width: size, height: size)
        .onTapGesture {
            guard viewModel.selectedUser != nil else {
                viewModel.isPlayerSelectionPresented = true
                return
            }
            guard !isDebouncing else { return }
            isDebouncing = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isDebouncing = false
            }
            viewModel.tap(square: index)
        }
    }

    @ViewBuilder
    func winLine(_ squareSize: CGFloat) -> some View {
        if let winLine = viewModel.winLineType, let gameResult = viewModel.gameResult {
            DrawnShape(
                shape: MarkerLine(),
                color: gameResult == .win(.human) ? .blue : .red,
                lineWidth: squareSize / 1.5 / 5,
                duration: 0.25
            )
            .frame(width: computePlayfieldWidth(using: squareSize), height: 1)
            .rotationEffect(getWinLineRotation(winLine))
            .offset(getWinLineOffset(winLine, squareSize: squareSize))
        }
    }

    func alertTitle() -> String {
        var title: String = ""
        var symbol: String = ""
        if let alert = viewModel.alert {
            switch alert {
            case .youWin:
                symbol = ["🙌","🥇","🏆","✌️", "🎉"].randomElement()!
            case .youLose:
                symbol = ["🫣","😤","😭","🤬", "😱"].randomElement()!
            case .draw:
                symbol = ["🤝","⚔️","👀", "👋", "🎲"].randomElement()!
            default: break
            }
            let alertString = String(localized: alert.localized)
            title = "\(alertString) \(symbol)"
        }
        return title
    }

    func alertMessage() -> LocalizedStringKey {
        guard
            viewModel.alert != .squareIsAlreadySelected
            && viewModel.alert != .tabBlocked
        else {
            return ""
        }
        guard let selectedUser = viewModel.selectedUser else {
            return ""
        }
        let gameDuration: LocalizedStringResource = .init("Game duration: \(String(format: "%.2f", viewModel.currentGameDuration ?? 0.0)) sec")
        let gamesWon: LocalizedStringResource = .init("Games won: \(selectedUser.gamesWonByHuman) / \(selectedUser.totalGamesCount)")
        let looses: LocalizedStringResource = .init("Looses: \(selectedUser.totalGamesCount - selectedUser.gamesWonByHuman - selectedUser.drawGamesCount)")
        let draws: LocalizedStringResource = .init("Draws: \(selectedUser.drawGamesCount)")
        let winRow: LocalizedStringResource = .init("Win row: \(selectedUser.gamesWonInARow)")
        let resultMessage: LocalizedStringKey = .init([gameDuration, gamesWon, looses, draws, winRow].map { String(localized: $0) }.joined(separator: "\n"))
        return resultMessage
    }
}
