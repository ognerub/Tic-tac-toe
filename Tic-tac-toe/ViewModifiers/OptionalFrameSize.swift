//
//  OptionalFrameSize.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//


import SwiftUI

struct OptionalFrameSize: ViewModifier {

    var size: CGFloat?

    func body(content: Content) -> some View {
        if let size {
            content
                .frame(width: size, height: size)
        } else {
            content
        }
    }
}
