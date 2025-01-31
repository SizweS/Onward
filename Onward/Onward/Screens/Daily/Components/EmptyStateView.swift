//
//  EmptyStateView.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/29.
//
import SwiftUI

import SwiftUI

struct EmptyDisciplinesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎯 Step 1: Create a discipline.")
                .font(.headline)
                .foregroundColor(.primary)

            Text("➕ Step 2: Add practices. Because just thinking about it doesn’t count.")
                .font(.headline)
                .foregroundColor(.primary)

            Text("📅 Step 3: Do the practices daily. No, actually do them.")
                .font(.headline)
                .foregroundColor(.primary)

            Text("✅ Step 4: Check them off. Because that little dopamine hit is real.")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading) {
                Text("🚀 Step 5: Become unstoppable.*")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("*…or at least slightly more disciplined than yesterday. We’ll take it.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
        }
        .multilineTextAlignment(.leading)
        .padding()
    }
}

#Preview {
    EmptyDisciplinesView()
}

