//
//  UserImageView.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//

import SwiftUI

struct UserImageView: View {

    @Binding var isSelected: Bool
    var imageName: String?
    var imageSize: CGFloat?


    init(
        _ isSelected: Binding<Bool>,
        imageName: String? = nil,
        imageSize: CGFloat? = nil
    ) {
        self._isSelected = isSelected
        self.imageName = imageName
        self.imageSize = imageSize
    }

    var body: some View {
        Circle()
            .fill(isSelected ? Color.blue : .black.opacity(0.15))
            .optionalFrameSize(imageSize)
            .overlay {
                if let iconName = imageName {
                    Image(systemName: iconName)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .padding(16)
                }
            }
    }
}

#Preview {
    UserImageView(.constant(true), imageName: "figure.arms.open")
}
