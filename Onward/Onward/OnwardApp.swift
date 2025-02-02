//
//  OnwardApp.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/09.
//

import SwiftUI
import SwiftData

@main
struct OnwardApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Discipline.self,
            Practice.self,
            
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        Task {
            await MomentumResetManager.shared.checkAndResetIfNeeded()

        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                        if let error = error {
                            print("Notification permission error: \(error)")
                        }
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
