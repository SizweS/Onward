//
//  Discipline.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/10.
//

import Foundation
import SwiftData

@Model
class Discipline: ReminderProtocol {
    var name: String
    var reminderHour: Int?
    var reminderMinute: Int?
    @Relationship(deleteRule: .cascade) var practices: [Practice] = []
    var momentum: Int
    var lastMomentumUpdate: Date
    
    init(name: String) {
        self.name = name
        self.reminderHour = nil
        self.reminderMinute = nil
        self.momentum = 0
        self.lastMomentumUpdate = Date()
    }
}
