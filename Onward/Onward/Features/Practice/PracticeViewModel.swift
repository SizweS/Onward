//
//  TaskViewModel.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/09.
//
import Foundation

class PracticeViewModel: ObservableObject {
    @Published
    private(set) var practice: Practice
    
    init(practice: Practice){
        self.practice = practice
    }
    
    func toggleCompletion() {
        practice.isCompleted.toggle()
    }
    
    func setReminderTime(at time: DateComponents) {
        practice.reminderTime = time
    }
    
    func removeReminder() {
        practice.reminderTime = nil
    }
    
    func getReminderTimeAsString() -> String {
        guard let hour  = practice.reminderTime?.hour,
              let minute = practice.reminderTime?.minute
        else {
            return ""
        }
        
        return String(format: "%02d:%02d", hour, minute)
    }
    
}
