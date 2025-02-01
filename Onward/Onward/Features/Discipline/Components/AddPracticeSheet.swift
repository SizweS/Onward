//
//  AddPracticeSheet.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/31.
//

import SwiftUI

struct AddPracticeSheet: View {
    let discipline: Discipline
    let onAdd: (String) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Create New Practice")) {
                    TextField("Practice Name", text: $name)
                        .focused($isFocused)
                        .submitLabel(.done)
                        .onSubmit(addPractice)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: addPractice)
                        .disabled(name.isEmpty)
                }
            }
        }
        .onAppear { isFocused = true }
    }
    
    private func addPractice() {
        guard !name.isEmpty else { return }
        onAdd(name)
        dismiss()
    }
}
