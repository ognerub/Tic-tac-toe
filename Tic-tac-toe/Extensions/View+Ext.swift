//
//  View+Ext.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//

import SwiftUI

extension View {

    func tabItem(_ title: LocalizedStringKey, _ imageName: String) -> some View {
        self.modifier(TabItemModifier(title, imageName))
    }

    func optionalFrameSize(_ size: CGFloat? = nil) -> some View {
        self.modifier(OptionalFrameSize(size: size))
    }

}
