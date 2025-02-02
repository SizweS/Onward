//
//  ReminderSheet.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/02/01.
//
import SwiftUI

struct TimePickerSheet: View {
    @Binding var selectedTime: Date
    let practice: Practice
    let onSetReminder: (Date) -> Void
    let onRemoveReminder: () -> Void
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Reminder Time")) {
                    DatePicker("Reminder Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                    
                    if let currentReminderTime = practice.reminderTime {
                        Text("Current Reminder: \(formattedTime(currentReminderTime))")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                
                Section {
                    Text("This reminder will go off every day to remind you to \(practice.name).")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Section {
                    Button("Set Reminder") {
                        onSetReminder(selectedTime)
                        dismiss() 
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    
                    if practice.reminderTime != nil {
                        Button("Remove Reminder", role: .destructive) {
                            onRemoveReminder()
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    // Sample practice with an initial reminder
    let samplePractice = Practice(name: "Read SwiftUI Documentation")
    samplePractice.reminderTime = Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date())
    
    // Sample date for the preview
    let sampleDate = Binding.constant(Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!)

    return TimePickerSheet(
        selectedTime: sampleDate,
        practice: samplePractice,
        onSetReminder: { time in
            print("Reminder set for \(time)")
        },
        onRemoveReminder: {
            print("Reminder removed")
        }
    )
}


