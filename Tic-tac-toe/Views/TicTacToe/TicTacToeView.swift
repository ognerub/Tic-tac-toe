//
//  TicTacToeView.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 04.02.2026.
//

import SwiftUI

struct TicTacToeView: View {

    // MARK: - Properties
    @EnvironmentObject var appSetting: AppSetting

    @StateObject private var viewModel: TicTacToeViewModel
    @State private var showSetting: Bool = false

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
                .environmentObject(appSetting)
            ScoreView(viewModel)
                .tabItem("Score cards", "list.number")
                .tag(TabItemType.scorecards)
            SettingView()
                .tabItem("Settings", "gear")
                .tag(TabItemType.settings)
                .environmentObject(appSetting)
        }
        .sheet(isPresented: $viewModel.isPlayerSelectionPresented, content: {
            UserSelectionView(viewModel) {
                viewModel.selectedTab = .scorecards
                viewModel.isAddUserPresented = true
            }
            .presentationDragIndicator(.visible)
        })
        .task {
            await viewModel.prepareUsers()
        }
    }

    private func blockingSelectionBinding() -> Binding<TabItemType> {
        Binding(
            get: { viewModel.selectedTab },
            set: { newValue in
                if newValue != .playground,
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
struct TicTacToeView_Preview: View {
    private let appContainer = Mocks.appContainer
    @StateObject private var appSettings = Mocks.appSettings

    var body: some View {
        TicTacToeView(appContainer)
            .environmentObject(appSettings)
            .environment(\.locale, Locale(identifier: appSettings.language.id))
    }
}

#Preview {
    TicTacToeView_Preview()
}
