//
//  AppLanguage.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 06.02.2026.
//


import SwiftUI
import Combine

enum AppLanguage: String, CaseIterable, Identifiable {
    case en, ru

    var id: String { rawValue }
    
    var displayName: LocalizedStringKey {
        switch self {
        case .en: return "English"
        case .ru: return "Russian"
        }
    }
}

