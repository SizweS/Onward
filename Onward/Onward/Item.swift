//
//  Item.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/09.
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
