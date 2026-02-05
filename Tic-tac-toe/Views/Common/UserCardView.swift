//
//  UserCardView.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//

import SwiftUI

struct UserCardView: View {

    let user: User
    @Binding var isSelected: Bool
    var font: Font = .default
    var imageSize: CGFloat? = nil

    var body: some View {
        VStack {
            UserImageView(
                $isSelected,
                imageName: user.iconName,
                imageSize: imageSize
            )
            Text("\(user.name)")
                .font(font)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}

#Preview {
    UserCardView(user: Mocks.users[0], isSelected: .constant(true))
}
