//
//  AppSetting.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 06.02.2026.
//


import Foundation
import Combine

@MainActor
final class AppSetting: ObservableObject {
    @Published var language: AppLanguage = .en

    init() {
        let local = Locale.current.language.languageCode?.identifier
        if local == "ru" {
            language = .ru
        } else {
            language = .en
        }
    }
}
