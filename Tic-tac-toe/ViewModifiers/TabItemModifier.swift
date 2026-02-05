//
//  TabItemModifier.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//


import SwiftUI

enum TabItemType {
    case playground
    case scorecards
}

struct TabItemModifier: ViewModifier {
    let title: LocalizedStringKey
    let imageName: String

    init(
        _ title: LocalizedStringKey,
        _ imageName: String
    ) {
        self.title = title
        self.imageName = imageName
    }

    func body(content: Content) -> some View {
        content
            .tabItem { Label(title, systemImage: imageName) }
    }
}
