//
//  UserDefaultsManager.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 06.02.2026.
//


import Foundation

enum StorageKeyNames: String {
    case lastSelectedPlayerId = "lastSelectedPlayerId"
}

final class UserDefaultsManager {

    static let shared = UserDefaultsManager()

    private let userDefaults = UserDefaults.standard

    var lastSelectedPlayerId: String? {
        get {
            userDefaults.string(forKey: StorageKeyNames.lastSelectedPlayerId.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: StorageKeyNames.lastSelectedPlayerId.rawValue)
        }
    }
}
