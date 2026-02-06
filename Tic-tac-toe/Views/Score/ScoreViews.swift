//
//  ScoreViews.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 06.02.2026.
//


import SwiftUI

extension ScoreView {
    @ViewBuilder
    func alertButtons() -> some View {
        Button("Close") { viewModel.clearAlert() }
        if case .error(_) = viewModel.alert  {
            Button("Retry") { sendUserData() }
        }
    }

    func alertMessage() -> some View {
        var resultMessage = ""
        let localized = String(localized: viewModel.alert?.localized ?? "").capitalized
        if case .error(let error) = viewModel.alert {
            let nsError = error as NSError
            resultMessage = localized + " Error code:\(nsError.code)"
        }
        return Text(resultMessage)
    }
}
