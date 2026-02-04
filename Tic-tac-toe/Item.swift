//
//  Item.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 04.02.2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
