//
//  TaskTests.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/09.
//

import Testing
@testable import Onward
import Foundation

struct PracticeViewModelTests {
    
    var sut: PracticeViewModel
    
    init() async throws {
        sut = PracticeViewModel(practice: Practice(name: "Drink water"))
    }
    
    @Test func testToggleCompletion() throws {
        
        // Initially, the task is not completed
        #expect(sut.practice.isCompleted == false)
        
        // Toggle to complete the task
        sut.toggleCompletion()
        #expect(sut.practice.isCompleted == true)
        
        //Toggle again to undo completion
        sut.toggleCompletion()
        #expect(sut.practice.isCompleted == false)
    }
    
    @Test  func testSetReminderTime() throws {
        let reminderTime = DateComponents(hour: 8, minute: 0)
        
        sut.setReminderTime(at: reminderTime)
        
        #expect(sut.practice.reminderTime == reminderTime)
    }
    
    @Test func testRemoveReminder() throws {
        sut.removeReminder()
        
        #expect(sut.practice.reminderTime == nil)
    }
    
    @Test func testGetReminderTimeAsString() throws {
        let reminderTime = DateComponents(hour: 8, minute: 0)
        sut.setReminderTime(at: reminderTime)
        
        #expect(sut.getReminderTimeAsString() == "08:00")
    }
}

