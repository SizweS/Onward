//
//  Task.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/09.
//

import Foundation
import SwiftData

@Model
class Practice: ReminderProtocol {
    var name: String
    var isCompleted: Bool = false
    var reminderHour: Int?
    var reminderMinute: Int?
    var discipline: Discipline?

    init(name: String) {
        self.name = name
        self.isCompleted = false
        self.reminderHour = nil
        self.reminderMinute = nil
        self.discipline = nil
    }
}
