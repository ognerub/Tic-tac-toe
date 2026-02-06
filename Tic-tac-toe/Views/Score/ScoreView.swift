//
//  ScoreView.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//

import SwiftUI

struct ScoreView: View {

    // MARK: - Properties
    @ObservedObject var viewModel: TicTacToeViewModel

    @State var isLoading: Bool = false

    init(_ viewModel: TicTacToeViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    // MARK: - Body
    var body: some View {
        NavigationSplitView {
            ZStack {
                List(selection: $viewModel.selectedUserScorecard) {
                    ForEach(viewModel.users) { user in
                        NavigationLink(value: user) {
                            HStack {
                                Text(user.name)
                                Spacer()
                                Text("\(user.gamesWonInARow)")
                            }
                        }
                    }
                    .onDelete { deleteUser($0) }
                }
                if isLoading {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.black.opacity(0.5))
                            .frame(width: 100, height: 100)
                        ProgressView()
                            .tint(.white)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { sendUserData() }
                    label: { Text("Send data") }
                }
                ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
                ToolbarItem {
                    Button { viewModel.isAddUserPresented = true }
                    label: { Label("Add User", systemImage: "plus") }
                }
            }
        } detail: {
            if let user = viewModel.selectedUserScorecard {
                UserDetailedView(user: user)
            } else {
                Text("Plaese, select user`s score card")
            }
        }
        .sheet(isPresented: $viewModel.isAddUserPresented) {
            AddUserView { addUser($0, $1) }
            .presentationDragIndicator(.visible)
        }
        .task {
            await viewModel.load()
        }
        .alert(
            "",
            isPresented: Binding(get: { viewModel.alert != nil }, set: { _ in }),
            actions: { alertButtons() },
            message: { alertMessage() }
        )
    }
}

// MARK: - Preview
#Preview {
    ScoreView(Mocks.viewModel)
}
