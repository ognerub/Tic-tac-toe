//
//  ScoreView.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//

import SwiftUI

struct ScoreView: View {

    // MARK: - Properties
    @ObservedObject private var viewModel: TicTacToeViewModel

    init(_ viewModel: TicTacToeViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    // MARK: - Body
    var body: some View {
        NavigationSplitView {
            List(selection: $viewModel.selectedUser) {
                ForEach(viewModel.users, id: \.id) { user in
                    NavigationLink(value: user) {
                        HStack {
                            Text(user.name)
                            Spacer()
                            Text("\(user.gamesWonInARow)")
                        }
                    }
                }
                .onDelete { indexSet in
                    viewModel.deleteUser(at: indexSet)
                    if let _ = viewModel.selectedUser {
                        viewModel.selectedUser = nil
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
                ToolbarItem {
                    Button { viewModel.isAddUserPresented = true }
                    label: { Label("Add User", systemImage: "plus") }
                }
            }
        } detail: {
            if let user = viewModel.selectedUser {
                UserDetailedView(user: user)
            } else {
                Text("Plaese, select user`s score card")
            }
        }
        .navigationDestination(for: UUID.self) { id in
            if let user = viewModel.users.first(where: { $0.id == id }) {
                Text("User with name \(user.name)")
            }
        }
        .sheet(isPresented: $viewModel.isAddUserPresented) {
            AddUserView { name, image in
                let newUser = viewModel.addUser(name: name, image: image)
                viewModel.selectedUser = newUser
                viewModel.isAddUserPresented = false
            }
            .presentationDragIndicator(.visible)
        }
        .onAppear {
            viewModel.load()
        }
    }
}

// MARK: - Preview
#Preview {
    ScoreView(Mocks.viewModel)
}
