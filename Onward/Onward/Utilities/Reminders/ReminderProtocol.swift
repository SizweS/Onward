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
              hour >= 0 && hour < 24,
              let minute = reminderMinute,
              minute >= 0 && minute < 60
        else {
            return ""
        }
        
        return String(format: "%02d:%02d", hour, minute)
    }
    
}
