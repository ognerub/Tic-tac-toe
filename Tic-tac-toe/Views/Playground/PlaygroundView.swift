//
//  PlaygroundView.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//

import SwiftUI

struct PlaygroundView: View {

    // MARK: - Properties
    @ObservedObject private var viewModel: TicTacToeViewModel

    @State private var isDebouncing: Bool = false

    // MARK: - Init
    init(_ viewModel: TicTacToeViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    // MARK: - Body
    var body: some View {
        GeometryReader { geo in
            HStack {
                Spacer()
                VStack(spacing: 32) {
                    Spacer()
                    if isPortrait(geo) {
                        TitleView()
                    }
                    playground(geo)
                    currentUserInfo(geo)
                    Spacer()
                }
                .padding(.horizontal, Sizes.padding)
                Spacer()
            }
        }
        .alert(
            viewModel.alert?.rawValue ?? "",
            isPresented: bindingAlertPresenting(),
            actions: { Button("Retry") { retryAction() }
            },
            message: { Text(alertMessage()) }
        )
    }

    // MARK: - Private views

    private func playground(_ geo: GeometryProxy) -> some View {
        ZStack {
            let squareSize = computeSquareSize(using: geo)
            playfield(squareSize)
            winLine(squareSize)
        }
    }

    private func currentUserInfo(_ geo: GeometryProxy) -> some View {
        ZStack {
            Rectangle()
                .fill(.clear)
                .frame(height: 100)
            if let user = viewModel.selectedUser, isPortrait(geo) {
                Text("Current user is \(user.name)")
            }
        }
        .onTapGesture {
            viewModel.isPlayerSelectionPresented = true
        }
    }

    @ViewBuilder
    private func marker(at index: Int, squareSize: CGFloat) -> some View {
        switch markerType(at: index) {
        case .player:
            AnimatedXMarker(size: squareSize / 1.5)
        case .computer:
            AnimatedOMarker(size: squareSize / 1.5)
        case .none:
            EmptyView()
        }
    }

    private func playfield(_ squareSize: CGFloat) -> some View {
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

    private func square(at index: Int, size: CGFloat) -> some View {
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
    private func winLine(_ squareSize: CGFloat) -> some View {
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

    private func alertMessage() -> LocalizedStringKey {
        guard
            viewModel.alert != .squareIsAlreadySelected
            && viewModel.alert != .tabBlocked
        else {
            return ""
        }
        let gameDuration: LocalizedStringKey = .init(
            stringLiteral: """
            Game duration: \(String(format: "%.2f", viewModel.currentGameDuration ?? 0.0)) sec
            Games won: \(viewModel.gamesWonByHuman) / \(viewModel.totalGamesCount)
            Looses: \(viewModel.totalGamesCount - viewModel.gamesWonByHuman - viewModel.drawGamesCount)
            Draws: \(viewModel.drawGamesCount)
            Win row: \(viewModel.gamesWonInARow)
            """
        )
        return gameDuration
    }

    // MARK: - Private methods

    private func retryAction() {
        defer { viewModel.clearAlert() }
        guard
            viewModel.alert != .squareIsAlreadySelected
            && viewModel.alert != .tabBlocked
        else {
            return
        }
        viewModel.reset(computerStarts: viewModel.alert == .youLoose)
    }

    private func computePlayfieldWidth(using size: CGFloat) -> CGFloat {
        return size * 3 + Sizes.totalSpacing
    }

    private func computeSquareSize(using geo: GeometryProxy) -> CGFloat {
        let side = min(geo.size.width, geo.size.height)
        let computedWidth = side - Sizes.totalPadding - Sizes.totalSpacing
        return computedWidth / Sizes.columnsCount
    }

    private func isPortrait(_ geo: GeometryProxy) -> Bool {
        return min(geo.size.width, geo.size.height) != geo.size.height
    }

    private func markerType(at index: Int) -> MarkerType {
        if viewModel.humanMoves.contains(index) { return .player }
        if viewModel.computerMoves.contains(index) { return .computer }
        return .none
    }

    private func bindingAlertPresenting() -> Binding<Bool> {
        .init(
            get: {
                viewModel.alert != nil
            },
            set: { _ in viewModel.clearAlert() }
        )
    }

    private func getWinLineRotation(_ winLineType: WinLineType?) -> Angle {
        switch winLineType {
        case .vertical(_): Angle(degrees: 90)
        case .diagonal(direction: 0): Angle(degrees: 45)
        case .diagonal(direction: 1): Angle(degrees: -45)
        default: Angle(degrees: 0)
        }
    }

    private func getWinLineOffset(
        _ winLineType: WinLineType?,
        squareSize: CGFloat
    ) -> CGSize {
        let offset = squareSize + Sizes.padding
        return switch winLineType {
        case .horizontal(row: 0):
            .init(width: 0, height: -offset)
        case .horizontal(row: 2):
            .init(width: 0, height: offset)
        case .vertical(column: 0):
            .init(width: -offset, height: 0)
        case .vertical(column: 2):
            .init(width: offset, height: 0)
        default:
            .init(width: 0, height: 0)
        }
    }
}

// MARK: - Nested types
extension PlaygroundView {
    enum WinLineType {
        case horizontal(row: Int)
        case vertical(column: Int)
        case diagonal(direction: Int)
    }

    private enum MarkerType {
        case player
        case computer
        case none
    }

    private enum Sizes {
        static let padding: CGFloat = 16.0
        static let spacing: CGFloat = 10.0
        static let columnsCount: CGFloat = 3.0

        static var totalSpacing: CGFloat {
            spacing * (columnsCount - 1.0)
        }

        static var totalPadding: CGFloat {
            Sizes.padding * 2.0
        }
    }
}

// MARK: - Preview
#Preview {
    PlaygroundView(Mocks.viewModel)
}
