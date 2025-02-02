//
//  CodeSteps.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/02/01.
//

import SwiftUI

struct CodeStep: Identifiable {
    let id = UUID()
    let emoji: String
    let title: String
    let description: String
}

struct CodeStepView: View {
    let step: CodeStep
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(step.emoji) \(step.title)")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(step.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

struct CodeView: View {
    let title: String
    let steps: [CodeStep]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title)
            
            ForEach(steps) { step in
                CodeStepView(step: step)
            }
        }
        .multilineTextAlignment(.leading)
        .padding()
    }
}
