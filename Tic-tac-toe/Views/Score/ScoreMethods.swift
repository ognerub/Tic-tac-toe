//
//  ScoreMethods.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 06.02.2026.
//

import SwiftUI

extension ScoreView {
    func sendUserData() {
        guard !isLoading else { return }
        defer { viewModel.clearAlert() }
        Task {
            do {
                isLoading = true
                defer { isLoading = false }
                try await viewModel.sendUserData()
                viewModel.showAlert(.successSending)
            } catch {
                viewModel.showAlert(.error(error))
            }
        }
    }

    func addUser(_ name: String, _ image: String) {
        Task { @MainActor in
            let newUser = await viewModel.addUser(name: name, image: image)
            viewModel.selectedUserScorecard = newUser
            viewModel.isAddUserPresented = false
        }
    }

    func deleteUser(_ indexSet: IndexSet) {
        Task { @MainActor in
            indexSet
                .map { viewModel.users[$0] }
                .forEach {
                    if viewModel.selectedUser?.id == $0.id {
                        viewModel.selectedUser = nil
                    }
                }
            await viewModel.deleteUser(at: indexSet)
            if let _ = viewModel.selectedUserScorecard {
                viewModel.selectedUserScorecard = nil
            }
        }
    }
}
