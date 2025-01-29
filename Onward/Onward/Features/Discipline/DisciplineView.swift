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
    @State private var newPracticeName = ""
    @State private var presentTimePicker = false
    @State private var selectedTime = Date()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Discipline name
                Text(discipline.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                // Circular Progress View for tasks
                CircularProgressView(
                    completed: discipline.practices.filter { $0.isCompleted }.count,
                    remaining: discipline.practices.filter { !$0.isCompleted }.count
                )
               .frame(height: 150)
                
                // Practices List
                VStack(alignment: .leading, spacing: 10) {
                    Text("Practices")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(discipline.practices) { practice in
                        PracticeView(practice: practice)
                            .padding(.horizontal)
                    }
                    .onDelete(perform: deletePractice)
                    
                    Button(action: { showingAddPractice = true }) {
                        Label("Add Practice", systemImage: "plus.circle.fill")
                    }
                    .padding([.horizontal, .top])
                }
                
                Divider()
                
                // Momentum Spiral Progress View
                VStack(spacing: 10) {
                    Text("Momentum")
                        .font(.headline)
                    SpiralProgressView(
                        completed: discipline.momentum,
                        remaining: discipline.goalDays - discipline.momentum
                    )
                    .frame(height: 250)
                }
            }
        }
        .sheet(isPresented: $showingAddPractice) {
            NavigationView {
                Form {
                    TextField("Practice Name", text: $newPracticeName)
                }
                .navigationTitle("New Practice")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingAddPractice = false
                        newPracticeName = ""
                    },
                    trailing: Button("Add") {
                        addPractice()
                        showingAddPractice = false
                        newPracticeName = ""
                    }
                    .disabled(newPracticeName.isEmpty)
                )
            }
        }
    }
    
    private func addPractice() {
        withAnimation {
            let practice = Practice(name: newPracticeName)
            practice.discipline = discipline
            discipline.practices.append(practice)
            try? modelContext.save()
        }
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




