//
//  DailyScreen.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/11.
//

import SwiftUI
import SwiftData

struct JourneyView: View {
    @Query var disciplines: [Discipline]
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddDiscipline = false
    
    var body: some View {
        NavigationStack {
            if disciplines.isEmpty {
                OnwardCode()
                    .navigationTitle("Add Disciplines")
            } else {
                List {
                    ForEach(disciplines) { discipline in
                        NavigationLink(value: discipline) {
                            DisciplineRow(discipline: discipline)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                modelContext.delete(discipline)
                                // TODO: Delete reminder
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .navigationTitle("Disciplines")
                .navigationDestination(for: Discipline.self) { discipline in
                    DisciplineView(discipline: discipline)
                }
            }
        }
        .sheet(isPresented: $showingAddDiscipline) {
            AddDisciplineSheet(isPresented: $showingAddDiscipline)
            .presentationDetents([.fraction(0.25)])
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Spacer()
                    Button(action: { showingAddDiscipline = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                    }
                    .foregroundStyle(.purple)
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Discipline.self, configurations: config)
    
    // Insert disciplines directly into the container
    let disciplineNames = ["Health", "Mindset", "Creative", "Family", "Love life", "Work", "Personal learning", "growth" ]
    for name in disciplineNames {
        let discipline = Discipline(name: name, goalDays: 30)
        let practice = Practice(name: "Sample Practice")
        practice.discipline = discipline
        discipline.practices.append(practice)
        container.mainContext.insert(discipline)
    }
    
    return NavigationStack {
        JourneyView()
    }
    .modelContainer(container)
}







