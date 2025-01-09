//
//  Task.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/09.
//

import Foundation

struct Task: Identifiable {
    let id: UUID = UUID()
    let name: String
    var isCompleted: Bool = false
    var reminderTime: DateComponents? = nil
}
