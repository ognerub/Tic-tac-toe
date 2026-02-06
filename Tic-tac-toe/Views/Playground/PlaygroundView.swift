//
//  PlaygroundView.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//

import SwiftUI

struct PlaygroundView: View {

    // MARK: - Properties
    @EnvironmentObject var appSetting: AppSetting

    @ObservedObject var viewModel: TicTacToeViewModel

    @State var isDebouncing: Bool = false

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
            alertTitle(),
            isPresented: bindingAlertPresenting(),
            actions: { Button("Retry") { retryAction() }
            },
            message: { Text(alertMessage()) }
        )
    }
}

// MARK: - Preview
#Preview {
    PlaygroundView(Mocks.viewModel)
}
