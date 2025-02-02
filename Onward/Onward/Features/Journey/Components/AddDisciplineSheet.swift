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
    @State private var daysText = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, days
    }
    
    private func saveDiscipline() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let discipline = Discipline(name: name, goalDays: Int(daysText) ?? 0)
        modelContext.insert(discipline)
        
        try? modelContext.save()
        isPresented = false
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header:  Text("Create New Discipline")) {
                    TextField("Discipline Name", text: $name)
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .days
                        }
                    
                    TextField("Commitment Days", text: $daysText)
                        .focused($focusedField, equals: .days)
                        .integersOnly($daysText)
                        .submitLabel(.done)
                        .onSubmit(saveDiscipline)
                }
            }
           // .navigationTitle("New Discipline")
           // .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        saveDiscipline()
                    }
                    .disabled(name.isEmpty || Int(daysText) == nil)
                }
                
                ToolbarItem(placement: .keyboard) {
                    Button{
                        focusedField = nil
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
                
                ToolbarItem(placement: .keyboard) {
                    Spacer()
                }
                
                if focusedField == .days {
                    ToolbarItem(placement: .keyboard) {
                        
                        Button("Done") {
                            focusedField = nil
                            saveDiscipline()
                        }
                        .disabled(name.isEmpty || Int(daysText) == nil)
                    }
                }
                    
            }
        }
    }
    
}
