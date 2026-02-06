//
//  PlaygroundNestedTypes.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 06.02.2026.
//


import SwiftUI

extension PlaygroundView {
    enum WinLineType {
        case horizontal(row: Int)
        case vertical(column: Int)
        case diagonal(direction: Int)
    }

    enum MarkerType {
        case player
        case computer
        case none
    }

    enum Sizes {
        static let padding: CGFloat = 32.0
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
