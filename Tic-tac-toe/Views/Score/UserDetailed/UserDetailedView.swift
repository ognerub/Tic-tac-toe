//
//  UserDetailedView.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//

import SwiftUI

struct UserDetailedView: View {

    var user: User

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                UserCardView(
                    user: user,
                    isSelected: .constant(true),
                    font: .headline,
                    imageSize: 300
                )
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total games: \(user.totalGamesCount)")
                    Text("Wins: \(user.gamesWonByHuman)")
                    Text("Looses: \(user.totalGamesCount - user.gamesWonByHuman - user.drawGamesCount)")
                    Text("Draws: \(user.drawGamesCount)")
                    Text("Best win row: \(user.gamesWonInARow)")
                    Text("Total in game time: \(String(format: "%.2f", user.totalInGameTime)) sec")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
        }
    }
}

#Preview {
    UserDetailedView(user: Mocks.users[0])
}
