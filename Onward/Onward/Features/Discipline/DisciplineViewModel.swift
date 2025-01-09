//
//  DisciplineViewModel.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/10.
//

import Foundation

class DisciplineViewModel: ObservableObject {
    @Published
    private(set) var discipline: Discipline
    
    init(_ discipline: Discipline){
        self.discipline = discipline
    }
    
    func addPractice(_ practice: Practice) {
        discipline.practices.append(practice)
    }
    
    func removePractice(by practiceId: UUID) {
        if let index = discipline.practices.firstIndex(where: { $0.id == practiceId }) {
            discipline.practices.remove(at: index)
        }
    }
    
    func setReminderTime(_ time: DateComponents) {
            discipline.reminderTime = time
        }
    
    func getReminderTimeAsString() -> String {
        guard let hour  = discipline.reminderTime?.hour,
              let minute = discipline.reminderTime?.minute
        else {
            return ""
        }
        
        return String(format: "%02d:%02d", hour, minute)
    }
    
}
