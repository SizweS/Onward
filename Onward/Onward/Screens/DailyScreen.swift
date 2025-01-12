//
//  DailyScreen.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/11.
//

import SwiftUI
import SwiftData

struct DailyScreen: View {
    @Query var disciplines: [Discipline]
    @Environment(\.modelContext) private var modelContext
    
    @State private var showingAddDiscipline = false
    @State private var newDisciplineName = ""
    @State private var newGoalDays = 30 // Default goal days
    @State private var showingDeleteConfirmation = false
    @State private var disciplineToDelete: Discipline?

    var body: some View {
        NavigationStack {
            TabView {
                ForEach(disciplines) { discipline in
                    ZStack(alignment: .topLeading) {
                        ScrollView {
                            DisciplineView(discipline: discipline)
                                .padding()
                        }
                        
                        // Floating Menu Button
                        Menu {
                            Button(role: .destructive) {
                                disciplineToDelete = discipline
                                showingDeleteConfirmation = true
                            } label: {
                                Label("Delete Discipline", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.title)
                                .padding()
                        }
                        .padding(.leading)
                        .padding(.top)
                    }
                    .navigationTitle("Daily Disciplines")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddDiscipline = true }) {
                        Label("Add Discipline", systemImage: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddDiscipline) {
                NavigationView {
                    Form {
                        Section(header: Text("Discipline Details")) {
                            TextField("Discipline Name", text: $newDisciplineName)
                                .textContentType(.name)
                                .disableAutocorrection(true)
                            
                            Stepper(value: $newGoalDays, in: 1...365, step: 1) {
                                Text("Goal Days: \(newGoalDays)")
                            }
                        }
                    }
                    .navigationTitle("New Discipline")
                    .navigationBarItems(
                        leading: Button("Cancel") {
                            resetForm()
                        },
                        trailing: Button("Add") {
                            addDiscipline()
                            resetForm()
                        }
                        .disabled(newDisciplineName.isEmpty)
                    )
                }
            }
            .confirmationDialog("Are you sure you want to delete this discipline?", isPresented: $showingDeleteConfirmation, actions: {
                Button("Delete", role: .destructive) {
                    if let discipline = disciplineToDelete {
                        deleteDiscipline(discipline)
                    }
                }
                Button("Cancel", role: .cancel) {}
            })
        }
    }
    
    private func resetForm() {
        showingAddDiscipline = false
        newDisciplineName = ""
        newGoalDays = 30
    }
    
    private func addDiscipline() {
        withAnimation {
            let newDiscipline = Discipline(name: newDisciplineName, goalDays: newGoalDays)
            modelContext.insert(newDiscipline)
            try? modelContext.save()
        }
    }
    
    private func deleteDiscipline(_ discipline: Discipline) {
        withAnimation {
            modelContext.delete(discipline)
            try? modelContext.save()
        }
    }
}




#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Discipline.self, configurations: config)
    
    // Insert disciplines directly into the container
    let disciplineNames = ["Meditation", "Learning", "Reading"]
    for name in disciplineNames {
        let discipline = Discipline(name: name, goalDays: 30)
        let practice = Practice(name: "Sample Practice")
        practice.discipline = discipline
        discipline.practices.append(practice)
        container.mainContext.insert(discipline)
    }
    
    return NavigationStack {
        DailyScreen()
    }
    .modelContainer(container)
}







