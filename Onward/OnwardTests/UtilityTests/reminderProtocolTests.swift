//
//  reminderProtocolTests.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/10.
//

import Testing
import Foundation

@testable import Onward

struct reminderProtocolTests {
    
    struct Testreminder: ReminderProtocol {
        var reminderHour: Int?
        var reminderMinute: Int?
    }
    
    @Test func testGetReminderTimeAsString() throws {
        // Valid time
        let reminder1 = Testreminder(reminderHour: 8, reminderMinute: 0)
        #expect(reminder1.getReminderTimeAsString() == "08:00")
        
        // Different valid time
        let reminder2 = Testreminder(reminderHour: 10, reminderMinute: 0)
        #expect(reminder2.getReminderTimeAsString() == "10:00")
        
        // nil time
        let reminder3 = Testreminder()
        #expect(reminder3.getReminderTimeAsString() == "")
        
        // Invalid components
        let reminder4 = Testreminder(reminderHour: 10000, reminderMinute: 300000000)
        #expect(reminder4.getReminderTimeAsString() == "")
        
    }
}
