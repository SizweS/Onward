//
//  TaskTests.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/09.
//

import Testing
@testable import Onward
import Foundation

struct TaksTests {
    
    var sut: TaskViewModel
    
    init() async throws {
        sut = TaskViewModel(task: Task(name: "Drink water"))
    }
    
    @Test func testToggleCompletion() throws {
        
        // Initially, the task is not completed
        #expect(sut.task.isCompleted == false)
        
        // Toggle to complete the task
        sut.toggleCompletion()
        #expect(sut.task.isCompleted == true)
        
        //Toggle again to undo completion
        sut.toggleCompletion()
        #expect(sut.task.isCompleted == false)
    }
    
    @Test  func testSetReminderTime() throws {
        let reminderTime = DateComponents(hour: 8, minute: 0)
        
        sut.setReminderTime(at: reminderTime)
        
        #expect(sut.task.reminderTime == reminderTime)
    }
    
    @Test func testRemoveReminder() throws {
        sut.removeReminder()
        
        #expect(sut.task.reminderTime == nil)
    }
    
    @Test func testGetReminderTimeAsString() throws {
        let reminderTime = DateComponents(hour: 8, minute: 0)
        sut.setReminderTime(at: reminderTime)
        
        #expect(sut.getReminderTimeAsString() == "08:00")
    }
}

