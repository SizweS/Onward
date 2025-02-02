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
    @Bindable var discipline: Discipline
    
    @State private var showingAddPractice = false
    @FocusState private var isFocused: Bool
    @State private var selectedTime = Date()
    @State private var selectedPractice: Practice?
    
    @State private var showingDisciplineCode = false
    @State private var showingResetAlert = false
    
    var body: some View {
        Group {
            if discipline.practices.isEmpty {
                DisciplineCode()
            } else {
                List {
                    Section("Today's Progress") {
                        ProgressCard(
                            completed: discipline.practices.filter { $0.isCompleted }.count,
                            remaining: discipline.practices.filter { !$0.isCompleted }.count,
                            foregroundStyle: Color.cyan,
                            image: .daily
                        )
                    }
                    
                    Section("Practices") {
                        ForEach(discipline.practices) { practice in
                            VStack(alignment: .leading) {
                                PracticeView(practice: practice)
                                if let reminderTime = practice.reminderTime {
                                    HStack {
                                        Image(systemName: "alarm")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                        Text(": \(formattedTime(reminderTime))")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .swipeActions {
                                Button {
                                    selectPracticeAndPresentSheet(practice)
                                } label: {
                                    Label("Set Reminder", systemImage: "bell.fill")
                                }
                                .tint(.indigo)
                                
                                Button(role: .destructive) {
                                    deletePractice(practice)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                        }
                    }
                    
                    Section("Momentum") {
                        ProgressCard(
                            completed: discipline.momentum,
                            remaining: discipline.goalDays - discipline.momentum,
                            foregroundStyle: Color.purple,
                            image: .momentum
                        )
                    }
                    
                    Button(action: { showingResetAlert = true }) {
                        Label("Reset", systemImage: "arrow.clockwise.circle.fill")
                    }
                    .foregroundStyle(.orange)
                }
                .alert("Reset Discipline", isPresented: $showingResetAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Reset", role: .destructive) {
                        resetDiscipline()
                    }
                } message: {
                    Text("Are you sure? This will reset your momentum to 0 days and clear all practice completions.")
                }
                .navigationTitle(discipline.name)
            }
        }
        .toolbar {
            if !discipline.practices.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingDisciplineCode = true }) {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Button(action: { showingAddPractice = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Practice")
                        }
                        .font(.headline)
                    }
                    Spacer()
                }
            }
        }
        .sheet(item: $selectedPractice) { practice in
            TimePickerSheet(
                selectedTime: $selectedTime,
                practice: practice,
                onSetReminder: { time in
                    scheduleReminder(for: practice, at: time)
                },
                onRemoveReminder: {
                    removeReminder(for: practice)
                }
            )
        }
        .sheet(isPresented: $showingAddPractice) {
            AddPracticeSheet(discipline: discipline) { practiceName in
                guard !practiceName.isEmpty else { return }
                addPractice(name: practiceName)
            }
            .presentationDetents([.height(200)])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showingDisciplineCode) {
            DisciplineCode()
        }
    }
    
    private func addPractice(name: String) {
        let practice = Practice(name: name)
        modelContext.insert(practice)
        discipline.practices.append(practice)
        try? modelContext.save()
    }
    
    private func resetDiscipline() {
        discipline.momentum = 0
        discipline.lastMomentumUpdate = Date()
        discipline.practices.forEach { practice in
            practice.isCompleted = false
        }
        try? modelContext.save()
    }
    
    private func selectPracticeAndPresentSheet(_ practice: Practice) {
        selectedPractice = practice
        selectedTime = practice.reminderTime ?? Date()
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func scheduleReminder(for practice: Practice, at time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "\(discipline.name) Reminder"
        content.body = "Remember to \(practice.name)"
        content.sound = .default
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "\(discipline.name)_\(practice.name)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
        
        practice.reminderTime = time
        try? modelContext.save()
    }
    
    private func removeReminder(for practice: Practice) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["\(discipline.name)_\(practice.name)"]
        )
        practice.reminderTime = nil
        try? modelContext.save()
    }
    
    private func deletePractice(_ practice: Practice) {
        removeReminder(for: practice)
        
        if let index = discipline.practices.firstIndex(where: { $0.id == practice.id }) {
            modelContext.delete(practice)
            try? modelContext.save()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Discipline.self, configurations: config)
    
    let discipline = Discipline(name: "Learning Swift", goalDays: 100)
    discipline.momentum = 30
    
    let practices = [
        "Read SwiftUI Documentation",
        "Complete Daily Coding Challenge",
        "Watch WWDC Videos",
        "Build Sample App",
        "Practice Debugging"
    ]
    
    for practiceName in practices {
        let practice = Practice(name: practiceName)
        practice.discipline = discipline
        discipline.practices.append(practice)
    }
    
    discipline.practices[0].isCompleted = true
    discipline.practices[2].isCompleted = true
    
    container.mainContext.insert(discipline)
    
    return NavigationStack {
        DisciplineView(discipline: discipline)
    }
    .modelContainer(container)
}
