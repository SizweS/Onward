//
//  CircularProgressBar.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/12.
//

import SwiftUI

struct CircularProgressView: View {
    let completed: Int
    let remaining: Int
    let foregroundStyle: Color
    
    private var percentage: Int {
        guard completed + remaining > 0 else { return 0 }
        
        return Int((Double(completed) / Double(completed + remaining)) * 100)
    }
    
    private var fillAmount: CGFloat {
            CGFloat(percentage) / 100.0
        }
    
    var body: some View {
        ZStack {
            
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 15))
                .foregroundStyle(Color.gray.opacity(0.2))
            
            Circle()
                .trim(from: 0, to: fillAmount)
                .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .round, lineJoin: .round))
                .foregroundStyle(foregroundStyle)
                .rotationEffect(.degrees(-90))
            
            HStack {
                Text ("\(percentage)\(Text("%").font(.title3))")
                    .font(.largeTitle)
                    .monospacedDigit()
    
            }
        }
        .padding()
    }
}

#Preview {
    CircularProgressView(completed: 4, remaining: 6, foregroundStyle: .cyan)
}
