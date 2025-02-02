//
//  MomentumResetManager.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/02/01.
//

import Foundation
import SwiftData
import Combine

enum MomentumError: Error {
    case contextNotFound
}

class MomentumResetManager {
    static let shared = MomentumResetManager()
    private let defaults = UserDefaults.standard
    private var timer: AnyCancellable?
    private let lastResetKey = "lastResetDate"
    private var testContainer: ModelContainer?
    
    private init() {
        startMidnightTimer()
    }
    
    func setTestContainer(_ container: ModelContainer) {
            testContainer = container
        }
    
    func checkAndResetIfNeeded() async {
        let calendar = Calendar.current
        let now = Date()
        
        let lastReset = defaults.object(forKey: lastResetKey) as? Date ?? .distantPast
        let isNewDay = !calendar.isDate(lastReset, inSameDayAs: now)
        
        if isNewDay {
            do {
                try await performMidnightReset()
                defaults.set(now, forKey: self.lastResetKey)
            } catch {
                print("Failed midnight reset: \(error)")
            }
        }
        
        startMidnightTimer()
    }
    
    @MainActor
    private func performMidnightReset() async throws {
        let container = testContainer ?? (try? ModelContainer(for: Discipline.self))
        guard let context = container?.mainContext else {
            throw MomentumError.contextNotFound
        }
        
        let fetchDescriptor = FetchDescriptor<Discipline>()
        let disciplines = try context.fetch(fetchDescriptor)
        
        for discipline in disciplines {
            let allCompleted = discipline.practices.allSatisfy { $0.isCompleted }
            if allCompleted {
                discipline.momentum += 1
            } else {
                discipline.momentum = 0
            }
            // Always reset practices for new day
            discipline.practices.forEach { $0.isCompleted = false }
        }
        
        try context.save()
    }
    
    private func startMidnightTimer() {
        let calendar = Calendar.current
        let now = Date()
        
        var components = DateComponents()
        components.hour = 0
        components.minute = 0
        
        guard let nextMidnight = calendar.nextDate(after: now,
                                                 matching: components,
                                                 matchingPolicy: .nextTime) else {
            return
        }
        
        let timeUntilMidnight = nextMidnight.timeIntervalSinceNow
        
        timer?.cancel()
        timer = Timer.publish(every: timeUntilMidnight, tolerance: 5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task {
                    await self?.checkAndResetIfNeeded()
                }
            }
    }
}
