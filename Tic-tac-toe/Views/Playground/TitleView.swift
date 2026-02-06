//
//  TitleView.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//

import SwiftUI

struct TitleView: View {

    private let title: LocalizedStringResource = "Tic-Tac-Toe"

    var body: some View {
        ZStack(alignment: .bottom) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            MarkerLine()
                .stroke(
                    Color.primary,
                    style: StrokeStyle(
                        lineWidth: 7,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .frame(width: computeMarkerLineWidth(), height: 1)
        }

    }

    private func computeMarkerLineWidth() -> CGFloat {
        let localizedTitle = String(localized: title)
        return localizedTitle.width(font: UIFont.preferredFont(forTextStyle: .largeTitle))
    }
}

#Preview {
    TitleView()
}
