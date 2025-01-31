//
//  Task.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/09.
//

import Foundation
import SwiftData

@Model
class Practice {
    var name: String
    var isCompleted: Bool = false
    var discipline: Discipline?

    init(name: String) {
        self.name = name
        self.isCompleted = false
        self.discipline = nil
    }
}
