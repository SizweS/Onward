//
//  reminderProtocol.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/10.
//

import Foundation

protocol ReminderProtocol {
    var reminderHour: Int? { get }
    var reminderMinute: Int? { get }
}

extension ReminderProtocol {
    func getReminderTimeAsString() -> String {
        guard let hour  = reminderHour,
              let minute = reminderMinute
        else {
            return ""
        }
        
        return String(format: "%02d:%02d", hour, minute)
    }
    
}
