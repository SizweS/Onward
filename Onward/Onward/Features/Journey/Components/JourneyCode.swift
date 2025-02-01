//
//  JourneyCode.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/29.
//
import SwiftUI

import SwiftUI

struct JourneyCode: View {
    static let steps = [
        CodeStep(emoji: "🎯",
                title: "Step 1: Add a discipline.",
                description: "A discipline is your commitment to improving a specific part of your life—whether it's strengthening your body, sharpening your mind, feeding your soul."),
        CodeStep(emoji: "💪",
                title: "Step 2: Create your discipline",
                description: "Name your discipline and set the amount of days you want to comit to this new discipline."),
        CodeStep(emoji: "ℹ️",
                title: "Info: The Discipline tile",
                description: "This will the amount of days you've stuck to this discipline *Momentum*, and the % of tasks completed today"),
        CodeStep(emoji: "🚰",
                title: "Step 3: Tap a Discipline Tile",
                description: "This will take you to the practices for that discipline and have some info on Todays progress and your Momentum"),
        CodeStep(emoji: "🚀",
                title: "Step 5: Become unstoppable.*",
                description: "Complete all practices in a discipline before midnight, and your momentum count will climb like a streak of wins. Miss it, and we reset—because discipline doesn't do 'carry-overs.'")
    ]
    
    var body: some View {
        CodeView(title: "The Onward Code", steps: Self.steps)
    }
}


#Preview {
    JourneyCode()
}

