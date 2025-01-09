//
//  CategoryView.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/10.
//

import Testing
@testable import Onward
import Foundation

struct DisciplineViewModelTests {
    
    var sut: DisciplineViewModel
    
    init() async throws {
        sut = DisciplineViewModel(Discipline(name: "75 Hard"))
    }
    
    @Test func AddPractice() throws {
        
        let practicesCount = sut.discipline.practices.count
        sut.addPractice(Practice(name: "Read 10 pages"))
        
        #expect(sut.discipline.practices.count == practicesCount + 1)
        #expect(sut.discipline.practices.contains(where: { $0.name == "Read 10 pages"}))
        
    }
    
    @Test func removePractice() throws {
        
        let practiceToRemove = Practice(name: "Follow Diet")
        sut.addPractice(practiceToRemove)
        let practicesCount = sut.discipline.practices.count
        
        sut.removePractice(by: practiceToRemove.id)
        
        #expect(sut.discipline.practices.count == practicesCount - 1)
        #expect(!sut.discipline.practices.contains(where: { $0.id == practiceToRemove.id }))
    }
    
    @Test func setReminderTime() throws {
        
           let reminderTime = DateComponents(hour: 9, minute: 0)
           
           sut.setReminderTime(reminderTime)
           
           #expect(sut.discipline.reminderTime == reminderTime)
    }
    
    @Test func updateExistingReminderTime() throws {

        let initialTime = DateComponents(hour: 9, minute: 0)
        sut.setReminderTime(initialTime)
        let newTime = DateComponents(hour: 18, minute: 30)
        
        sut.setReminderTime(newTime)
        
        #expect(sut.discipline.reminderTime == newTime)
        #expect(sut.discipline.reminderTime != initialTime)
    }

}
