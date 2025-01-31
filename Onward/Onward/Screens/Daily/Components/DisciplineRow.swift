//
//  DisciplineRow.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/29.
//
import SwiftUI

struct DisciplineRow: View {
    let discipline: Discipline
    @State private var showingReminderSheet = false
    
    var completionPercentage: Double {
        guard !discipline.practices.isEmpty else { return 0 }
        let completed = discipline.practices.filter { $0.isCompleted }.count
        return Double(completed) / Double(discipline.practices.count) * 100
    }
    
    var progressText: String {
        let completedDays = discipline.practices.filter { $0.isCompleted }.count
        return "\(completedDays)/\(discipline.goalDays) days"
    }
    
    var percentageText: String {
        return String(format: "%.0f%%", completionPercentage)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(discipline.name)
                        .font(.headline)
                    
                    Text(progressText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                
                HStack {
                    
                    Text(percentageText)
                        .font(.caption)
                        .foregroundColor(completionPercentage == 100 ? .green : .blue)
                }
                
                ProgressView(value: completionPercentage, total: 100)
                    .tint(completionPercentage == 100 ? .green : .blue)
            }
            
        }
        .padding(.vertical, 8)
    }
    
}


#Preview {
    NavigationStack {
        List {
            // With reminder
            DisciplineRow(discipline: {
                let discipline = Discipline(name: "Morning Routine", goalDays: 30)
                discipline.practices = [
                    Practice(name: "Meditation"),
                    Practice(name: "Reading")
                ]
                discipline.practices[0].isCompleted = true
                return discipline
            }())
            
            // Without reminder
            DisciplineRow(discipline: {
                let discipline = Discipline(name: "Evening Routine", goalDays: 60)
                discipline.practices = [
                    Practice(name: "Journal"),
                    Practice(name: "Plan Tomorrow")
                ]
                discipline.practices[0].isCompleted = true
                discipline.practices[1].isCompleted = true
                return discipline
            }())
        }
    }
}
