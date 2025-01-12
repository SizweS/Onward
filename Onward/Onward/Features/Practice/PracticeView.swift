//
//  TaskView.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/09.
//

import SwiftUI
import SwiftData

struct PracticeView: View {
    @Environment(\.modelContext) private var modelContext
    let practice: Practice
    
    @State private var selectedTime = Date() // Default time for date picker
    @State private var presentTimePicker: Bool = false
    
    private let generator = UIImpactFeedbackGenerator(style: .medium) // for haptic feedback
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: practice.isCompleted ? "circle.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(Color.green)
                
                Text(practice.name)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .onTapGesture {
                toggleCompletion()
            }
            
            Button(action: {
                presentTimePicker = true
            }) {
                Image(systemName: "clock.circle")
                    .font(.title3)
                Text(practice.getReminderTimeAsString())
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
                        setReminderTime(selectedTime)
                        presentTimePicker = false
                    }) {
                        Text("Set Reminder")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                                        
                    Button(action: {
                        removeReminder()
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
    
    private func toggleCompletion() {
        withAnimation {
            practice.isCompleted.toggle()
            try? modelContext.save()
            generator.impactOccurred()
        }
    }
    
    private func setReminderTime(_ date: Date) {
        withAnimation {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: date)
                practice.reminderHour = components.hour
                practice.reminderMinute = components.minute
                try? modelContext.save() // Save the changes to the database
            }
    }
    
    private func removeReminder() {
        withAnimation {
            practice.reminderHour = nil
            practice.reminderMinute = nil
            try? modelContext.save() // Save the changes to the database
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Practice.self, configurations: config)
        let practice = Practice(name: "Workout 1")
        return PracticeView(practice: practice)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container")
    }
}
