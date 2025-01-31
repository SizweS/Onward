//
//  EmptyStateView.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/29.
//
import SwiftUI

import SwiftUI

struct OnwardCode: View {
    var body: some View {
        Text("The Onward Code")
            .font(.title)
        VStack(alignment: .leading, spacing: 12) {

            Text("🎯 Step 1: Create a discipline.")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("A discipline is your commitment to improving a specific part of your life—whether it’s strengthening your body, sharpening your mind, feeding your soul or fixing your finances.")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("➕ Step 2: Add practices.")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Practices are actions that build your discipline. Want peace of mind? Try meditation. Want muscles? Lift something heavy. Want inspiration? Read something deep.")
                .font(.subheadline)
                .foregroundColor(.secondary)

            VStack(alignment: .leading) {
                Text("📅 Step 3: Complete Practices every Day.")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Consistency is your superpower. You don’t need perfection—just show up.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Text("✅ Step 4: Check Practices off.")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Checking off practices is like giving yourself a high-five. It feels good and keeps you moving forward.")
                .font(.subheadline)
                .foregroundColor(.secondary)

            VStack(alignment: .leading) {
                Text("🚀 Step 5: Become unstoppable.*")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("Complete all practices in a discipline before midnight, and your momentum count will climb like a streak of wins. Miss it, and we reset—because discipline doesn’t do ‘carry-overs.’")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .multilineTextAlignment(.leading)
        .padding()
    }
}


#Preview {
    OnwardCode()
}

