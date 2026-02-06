//
//  PlaygroundMethods.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 06.02.2026.
//


import SwiftUI

extension PlaygroundView {
    func retryAction() {
        defer { viewModel.clearAlert() }
        guard
            viewModel.alert != .squareIsAlreadySelected
            && viewModel.alert != .tabBlocked
        else {
            return
        }
        viewModel.reset(computerStarts: viewModel.alert == .youLose)
    }

    func computePlayfieldWidth(using size: CGFloat) -> CGFloat {
        return size * 3 + Sizes.totalSpacing
    }

    func computeSquareSize(using geo: GeometryProxy) -> CGFloat {
        let side = min(geo.size.width, geo.size.height)
        let computedWidth = side - Sizes.totalPadding - Sizes.totalSpacing
        return computedWidth / Sizes.columnsCount
    }

    func isPortrait(_ geo: GeometryProxy) -> Bool {
        return min(geo.size.width, geo.size.height) != geo.size.height
    }

    func markerType(at index: Int) -> MarkerType {
        if viewModel.humanMoves.contains(index) { return .player }
        if viewModel.computerMoves.contains(index) { return .computer }
        return .none
    }

    func bindingAlertPresenting() -> Binding<Bool> {
        .init(
            get: {
                viewModel.alert != nil
            },
            set: { _ in viewModel.clearAlert() }
        )
    }

    func getWinLineRotation(_ winLineType: WinLineType?) -> Angle {
        switch winLineType {
        case .vertical(_): Angle(degrees: 90)
        case .diagonal(direction: 0): Angle(degrees: 45)
        case .diagonal(direction: 1): Angle(degrees: -45)
        default: Angle(degrees: 0)
        }
    }

    func getWinLineOffset(
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
