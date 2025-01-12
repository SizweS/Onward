//
//  DailyScreen.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/11.
//

import SwiftUI
import SwiftData

struct DailyScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var disciplines: [Discipline]
    
    @State private var showingAddDiscipline = false
    @State private var newDisciplineName = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(disciplines) { discipline in
                    NavigationLink(destination: DisciplineView(discipline: discipline)) {
                        Text(discipline.name)
                            .font(.headline)
                    }
                }
                .onDelete(perform: deleteDiscipline)
            }
            .navigationTitle("Daily Disciplines")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddDiscipline = true }) {
                        Label("Add Discipline", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddDiscipline) {
                NavigationView {
                    Form {
                        TextField("Discipline Name", text: $newDisciplineName)
                    }
                    .navigationTitle("New Discipline")
                    .navigationBarItems(
                        leading: Button("Cancel") {
                            showingAddDiscipline = false
                            newDisciplineName = ""
                        },
                        trailing: Button("Add") {
                            addDiscipline()
                            showingAddDiscipline = false
                            newDisciplineName = ""
                        }
                        .disabled(newDisciplineName.isEmpty)
                    )
                }
                .presentationDetents([.height(200)])
            }
        }
    }
    
    private func addDiscipline() {
        let discipline = Discipline(name: newDisciplineName)
        modelContext.insert(discipline)
        try? modelContext.save()
    }
    
    private func deleteDiscipline(at offsets: IndexSet) {
        for index in offsets {
            let discipline = disciplines[index]
            modelContext.delete(discipline)
        }
        try? modelContext.save()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Discipline.self, configurations: config)
        return DailyScreen()
            .modelContainer(container)
    } catch {
        return Text("Failed to create container")
    }
}

