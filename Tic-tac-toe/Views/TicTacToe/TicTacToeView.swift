//
//  TicTacToeView.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 04.02.2026.
//

import SwiftUI

struct TicTacToeView: View {

    // MARK: - Properties
    @StateObject private var viewModel: TicTacToeViewModel

    // MARK: - Init
    init(_ appContainer: AppContainer) {
        self._viewModel = StateObject(wrappedValue: TicTacToeViewModel(appContainer))
    }

    // MARK: - Body
    var body: some View {
        TabView(selection: blockingSelectionBinding()) {
            PlaygroundView(viewModel)
                .tabItem("Playground", "dot.circle.and.hand.point.up.left.fill")
                .tag(TabItemType.playground)
                .onAppear {
                    if viewModel.selectedUser == nil {
                        viewModel.isPlayerSelectionPresented = true
                    }
                }
            ScoreView(viewModel)
                .tabItem("Score cards", "list.number")
                .tag(TabItemType.scorecards)
        }
        .sheet(isPresented: $viewModel.isPlayerSelectionPresented, content: {
            UserSelectionView(viewModel) {
                viewModel.selectedTab = .scorecards
                viewModel.isAddUserPresented = true
            }
            .presentationDragIndicator(.visible)
        })
    }

    private func blockingSelectionBinding() -> Binding<TabItemType> {
        Binding(
            get: { viewModel.selectedTab },
            set: { newValue in
                if newValue == .scorecards,
                   !viewModel.humanMoves.isEmpty || !viewModel.computerMoves.isEmpty {
                    viewModel.showAlert(.tabBlocked)
                    return
                }
                viewModel.selectedTab = newValue
            }
        )
    }
}

// MARK: - Preview
#Preview {
    TicTacToeView(Mocks.appContainer)
}
