//
//  Task.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/09.
//

import Foundation

struct Practice: Identifiable {
    let id: UUID = UUID()
    let name: String
    var isCompleted: Bool = false
    var reminderTime: DateComponents? = nil // The time at which a reminder should be triggered for this practice, if set.
}
