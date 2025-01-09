//
//  Discipline.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/10.
//

import Foundation

struct Discipline: Identifiable {
    let id: UUID = UUID()
    let name: String
    var reminderTime: DateComponents? = nil // The time at which a reminder should be triggered for this discipline, if set.
    var practices: [Practice] = [] // A list of practices associated with this discipline.
}
