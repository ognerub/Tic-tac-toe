//
//  UserSelectionView.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//

import SwiftUI

struct UserSelectionView: View {

    @Environment(\.dismiss) private var dismiss

    @ObservedObject private var viewModel: TicTacToeViewModel

    var onAddHandler: (() -> Void)?

    init(_ viewModel: TicTacToeViewModel, onAddHandler: (() -> Void)? = nil) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.onAddHandler = onAddHandler
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("User selection") {
                    LazyVGrid(
                        columns: Array(
                            repeating: .init(.flexible(), spacing: 10),
                            count: UIDevice.current.userInterfaceIdiom == .phone ? 3 : 5),
                        content: {
                        ForEach(viewModel.users) { user in
                            UserCardView(
                                user: user,
                                isSelected: isSelected(user)
                            )
                            .animation(.easeInOut, value: viewModel.selectedUser)
                            .onTapGesture {
                                if viewModel.selectedUser == user {
                                    viewModel.selectUser(nil)
                                } else {
                                    viewModel.selectUser(user)
                                }
                            }
                        }
                    })
                    .padding(16)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Create new") {
                        onAddHandler?()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm") {
                        dismiss()
                    }
                    .disabled(viewModel.selectedUser == nil)
                }
            }
        }
    }

    private func isSelected(_ user: User) -> Binding<Bool> {
        .init(get: {
            viewModel.selectedUser == user
        }, set: {
            _ in
        })
    }
}

#Preview {
    UserSelectionView(Mocks.viewModel)
}
