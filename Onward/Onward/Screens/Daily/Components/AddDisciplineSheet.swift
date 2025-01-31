//
//  AddDisciplineSheet.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/29.
//
import SwiftUI
import SwiftData

struct AddDisciplineSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var goalDays = 30
    
    private func saveDiscipline() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let discipline = Discipline(name: name, goalDays: goalDays)
        modelContext.insert(discipline)
        
        try? modelContext.save()
        isPresented = false
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Discipline Name", text: $name)
                Stepper("Goal Days: \(goalDays)", value: $goalDays, in: 1...365)
            }
            .navigationTitle("New Discipline")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        saveDiscipline()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
