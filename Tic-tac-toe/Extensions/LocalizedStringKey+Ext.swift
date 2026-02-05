//
//  LocalizedStringKey+Ext.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//


import SwiftUI

extension LocalizedStringKey {
    var stringValue: String {
        let mirror = Mirror(reflecting: self)
        if let value = mirror.children.first(where: { $0.label == "key" })?.value as? String {
            return value
        }
        return ""
    }
}
