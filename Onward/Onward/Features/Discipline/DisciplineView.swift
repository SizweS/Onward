//
//  DisciplineViewModel.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/10.
//

import SwiftUI
import SwiftData

struct DisciplineView: View {
    @Environment(\.modelContext) private var modelContext
    let discipline: Discipline
    
    @State private var showingAddPractice = false
    @FocusState private var isFocused: Bool
    @State private var presentTimePicker = false
    @State private var selectedTime = Date()
    
    var body: some View {
        List {
                Section("Todays Progress") {
                    CircularProgressView(
                        completed: discipline.practices.filter { $0.isCompleted }.count,
                        remaining: discipline.practices.filter { !$0.isCompleted }.count,
                        foregroundStyle: Color.cyan
                    )
                   .frame(height: 150)
                }
                
                Section("Practices") {
                    ForEach(discipline.practices) { practice in
                        PracticeView(practice: practice)
                    }
                    .onDelete(perform: deletePractice)
                }
                
                Button(action: { showingAddPractice = true }) {
                    Label("Add Practice", systemImage: "plus.circle.fill")
                }
                .foregroundStyle(.purple)            
            
                Section("Momentum") {
                    CircularProgressView(
                        completed: discipline.momentum,
                        remaining: discipline.goalDays - discipline.momentum,
                        foregroundStyle: Color.purple
                    )
                    .frame(height: 150)
                }
        }
        .navigationTitle(discipline.name)
        .sheet(isPresented: $showingAddPractice) {
            AddPracticeSheet(discipline: discipline) { practiceName in
                guard !practiceName.isEmpty else { return }
                addPractice(name: practiceName)
            }
            .presentationDetents([.height(200)])
            .presentationDragIndicator(.visible)
        }
        
    }
    
    private func addPractice(name: String) {
            let practice = Practice(name: name)
            practice.discipline = discipline
            discipline.practices.append(practice)
            try? modelContext.save()
        }
    
    private func deletePractice(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let practice = discipline.practices[index]
                discipline.practices.remove(at: index)
                modelContext.delete(practice)
            }
            try? modelContext.save()
        }
    }
}

#Preview {
    // Create a preview container
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Discipline.self, configurations: config)
    
    // Create sample discipline with various practices
    let discipline = Discipline(name: "Learning Swift", goalDays: 100)
    discipline.momentum = 30
    
    // Add sample practices
    let practices = [
        "Read SwiftUI Documentation",
        "Complete Daily Coding Challenge",
        "Watch WWDC Videos",
        "Build Sample App",
        "Practice Debugging"
    ]
    
    for practiceName in practices {
        let practice = Practice(name: practiceName)
        practice.discipline = discipline
        discipline.practices.append(practice)
    }
    
    // Mark some practices as completed
    discipline.practices[0].isCompleted = true
    discipline.practices[2].isCompleted = true
    
    // Add the discipline to the container
    container.mainContext.insert(discipline)
    
    // Create the navigation stack with our view
    return NavigationStack {
        DisciplineView(discipline: discipline)
    }
    .modelContainer(container)
}




