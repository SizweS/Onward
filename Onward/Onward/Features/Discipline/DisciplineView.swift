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
    
    @State private var showingDisciplineCode = false
    
    @State private var showingResetAlert = false
    
    var body: some View {
        Group {
            if discipline.practices.isEmpty {
                DisciplineCode()
            } else {
                List {
                    Section("Todays Progress") {
                        ProgressCard(
                            completed: discipline.practices.filter { $0.isCompleted }.count,
                            remaining: discipline.practices.filter { !$0.isCompleted }.count,
                            foregroundStyle: Color.cyan,
                            image: .daily)
                    }
                    
                    Section("Practices") {
                        ForEach(discipline.practices) { practice in
                            PracticeView(practice: practice)
                        }
                        .onDelete(perform: deletePractice)
                    }
                    
                    Section("Momentum") {
                        ProgressCard(
                            completed: discipline.momentum,
                            remaining: discipline.goalDays - discipline.momentum,
                            foregroundStyle: Color.purple,
                            image: .momentum
                        )
                    }
                    
                    Button(action: { showingResetAlert = true }) {
                        Label("Reset", systemImage: "trash.fill")
                    }
                    .foregroundStyle(.red)
                }
                .alert("Reset Discipline", isPresented: $showingResetAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Reset", role: .destructive) {
                        resetDiscipline()
                    }
                } message: {
                    Text("Are you sure? This will reset your momentum to 0 days and clear all practice completions.")
                }
                .navigationTitle(discipline.name)
            }
        }
        .toolbar {
            if !discipline.practices.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingDisciplineCode = true }) {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Button(action: { showingAddPractice = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Practice")
                        }
                        .font(.headline)
                    }
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showingAddPractice) {
            AddPracticeSheet(discipline: discipline) { practiceName in
                guard !practiceName.isEmpty else { return }
                addPractice(name: practiceName)
            }
            .presentationDetents([.height(200)])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showingDisciplineCode) {
            DisciplineCode()
        }
        
    }
    
    private func addPractice(name: String) {
        let practice = Practice(name: name)
        practice.discipline = discipline
        discipline.practices.append(practice)
        try? modelContext.save()
    }
    
    private func resetDiscipline() {
        discipline.momentum = 0
        discipline.lastMomentumUpdate = Date()
        discipline.practices.forEach { practice in
            practice.isCompleted = false
        }
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




