//
//  TaskView.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/09.
//

import SwiftUI

struct PracticeView: View {
    @State private var presentTimePicker = false
    @State private var selectedTime = Date() // Default time for date picker
    
    @ObservedObject var viewModel: PracticeViewModel
    
    private let generator = UIImpactFeedbackGenerator(style: .medium) // for haptic feedback
    
    var body: some View {
        HStack{
            HStack {
                Image(systemName: viewModel.practice.isCompleted ? "circle.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(Color.green)
                
                Text(viewModel.practice.name)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .onTapGesture {
                viewModel.toggleCompletion()
                
                generator.impactOccurred()
            }
            
            Button(action: {
                presentTimePicker = true
            }) {
                Image(systemName: "clock.circle")
                    .font(.title)
                Text(viewModel.getReminderTimeAsString())
            }
        }
        .padding()
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
                        viewModel.setReminderTime(at: components)
                        presentTimePicker = false
                    }) {
                        Text("Set Reminder")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                                        
                    Button(action: {
                        viewModel.removeReminder()
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
}

#Preview {
    PracticeView(viewModel: PracticeViewModel(practice: Practice(name: "To Do 1")))
}
