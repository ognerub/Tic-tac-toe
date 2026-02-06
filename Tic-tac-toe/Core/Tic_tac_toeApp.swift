//
//  Tic_tac_toeApp.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 04.02.2026.
//

import SwiftUI

@main
struct Tic_tac_toeApp: App {

    private let appContainer = AppContainer()
    @StateObject private var appSetting = AppSetting()

    var body: some Scene {
        WindowGroup {
            TicTacToeView(appContainer)
                .environmentObject(appSetting)
                .environment(\.locale, Locale(identifier: appSetting.language.id))
        }
    }
}
