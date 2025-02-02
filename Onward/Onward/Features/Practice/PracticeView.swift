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
    @Bindable var practice: Practice
    @State private var showingReminderSheet = false
    @State private var errorMessage: String?
    @State private var showingError = false
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    private func toggleCompletion() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            practice.isCompleted.toggle()
            try? modelContext.save()
            generator.impactOccurred()
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: toggleCompletion) {
                ZStack {
                    Circle()
                        .strokeBorder(practice.isCompleted ? Color.green : Color.secondary.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if practice.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.system(size: 24))
                    }
                }
            }
            
            Text(practice.name)
                .font(.body)
                .foregroundStyle(practice.isCompleted ? .secondary : .primary)
                .strikethrough(practice.isCompleted)
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
