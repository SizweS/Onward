//
//  DisciplineCode.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/02/01.
//

import SwiftUI

struct DisciplineCode: View {
    static let steps = [
        CodeStep(emoji: "➕",
                title: "Step 1: Add Practices",
                description: "Practices are actions that build your discipline. Want peace of mind? Try meditation. Want muscles? Lift something heavy. Want inspiration? Read something deep."),
        CodeStep(emoji: "📅",
                title: "Step 3: Complete Practices every Day.",
                description: "Consistency is your superpower. You don't need perfection—just show up."),
        CodeStep(emoji: "✅",
                title: "Step 4: Check Practices off.",
                description: "Checking off practices is like giving yourself a high-five. It feels good and keeps you moving forward."),
        CodeStep(emoji: "🚀",
                title: "Step 5: Become unstoppable.*",
                description: "Complete all practices in a discipline before midnight, and your momentum count will climb like a streak of wins. Miss it, and we reset—because discipline doesn't do 'carry-overs.'")
    ]
    
    var body: some View {
        CodeView(title: "The Onward Code", steps: Self.steps)
    }
}


#Preview {
    DisciplineCode()
}

