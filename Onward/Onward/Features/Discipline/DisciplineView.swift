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
        List {
            Section("Practices") {
                ForEach(discipline.practices) { practice in
                    PracticeView(practice: practice)
                }
                .onDelete(perform: deletePractice)
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: { showingAddPractice = true } ) {
                    Label("Add Practice", systemImage: "plus")
                }
            }
        }
        .navigationTitle(discipline.name)
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
            .presentationDetents([.height(200)])
        }
        .toolbar {
            Button(action: {
                presentTimePicker = true
            }) {
                Image(systemName: "clock.circle")
                Text(discipline.getReminderTimeAsString())
            }
        }
        .sheet(isPresented: $presentTimePicker) {
            VStack {
                DatePicker(
                    "Reminder Time",
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()

                HStack {
                    Button(action: {
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.hour, .minute], from: selectedTime)
                        discipline.reminderHour = components.hour
                        discipline.reminderMinute = components.minute
                        try? modelContext.save()
                        presentTimePicker = false
                    }) {
                        Text("Set Reminder")
                            .frame(maxWidth: .infinity)
                    }                    .buttonStyle(.borderedProminent)
                    
                    Button(action: {
                        discipline.reminderHour = nil
                        discipline.reminderMinute = nil
                        try? modelContext.save()
                        presentTimePicker = false
                    }) {
                        Text("Remove")
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .presentationDetents([.fraction(0.4), .medium])
            .presentationDragIndicator(.visible)
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
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Discipline.self, configurations: config)
        let discipline = Discipline(name: "Hard 75")
        return NavigationStack {
            DisciplineView(discipline: discipline)
        }
        .modelContainer(container)
    } catch {
        return Text("Failed to create container")
    }
}

