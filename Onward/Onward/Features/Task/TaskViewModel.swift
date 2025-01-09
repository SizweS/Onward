//
//  TaskViewModel.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/09.
//
import Foundation

class TaskViewModel: ObservableObject {
    @Published
    private(set) var task: Task
    
    init(task: Task){
        self.task = task
    }
    
    func toggleCompletion() {
        task.isCompleted.toggle()
    }
    
    func setReminderTime(at time: DateComponents) {
        task.reminderTime = time
    }
    
    func removeReminder() {
        task.reminderTime = nil
    }
    
    func getReminderTimeAsString() -> String {
        guard let hour  = task.reminderTime?.hour,
              let minute = task.reminderTime?.minute
        else {
            return ""
        }
        
        return String(format: "%02d:%02d", hour, minute)
    }
}
