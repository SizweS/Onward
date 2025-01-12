//
//  SpiralProgressView.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/12.
//

import SwiftUI

struct SpiralProgressView: View {
    let completed: Int
    let remaining: Int
    
    private var percentage: Int {
        guard completed + remaining > 0 else { return 0 }
        return Int((Double(completed) / Double(completed + remaining)) * 100)
    }
    
    private var fillAmount: CGFloat {
        CGFloat(percentage) / 100.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            
            ZStack {
                // Background spiral
                SpiralShape(progress: 1.0, spins: 3)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                    .frame(width: size, height: size)
                
                // Progress spiral
                SpiralShape(progress: fillAmount, spins: 3)
                    .stroke(
                        .cyan,
                        style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: size, height: size)
                
                // Center background for better text visibility
                Circle()
                    .fill(.background)
                    .frame(width: size * 0.4)
                
                // Ratio text
                VStack(spacing: 0) {
                    Text("\(completed)")
                        .font(.title3)
                        .monospacedDigit()
                    Text("of")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text("\(remaining + completed) days")
                        .font(.footnote)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct SpiralShape: Shape {
    let progress: CGFloat
    let spins: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let totalAngle = Double(spins) * 2 * .pi
        let points = 500
        
        // Calculate points along the spiral
        for i in 0...points {
            let percentage = CGFloat(i) / CGFloat(points)
            guard percentage <= progress else { break }
            
            let angle = percentage * totalAngle
            let currentRadius = radius * (0.2 + 0.8 * percentage)
            let x = center.x + currentRadius * cos(angle)
            let y = center.y + currentRadius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}

#Preview {
    VStack {
        SpiralProgressView(completed: 74, remaining: 1)
            .padding()
        SpiralProgressView(completed: 30, remaining: 70)
            .padding()
        SpiralProgressView(completed: 0, remaining: 100)
            .padding()
    }
}
