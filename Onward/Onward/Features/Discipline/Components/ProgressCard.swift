//
//  SpiralProgressView.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/12.
//

import SwiftUI

struct ProgressCard: View {
    let completed: Int
    let remaining: Int
    let foregroundStyle: Color
    let image: ImageResource
    
    var body: some View {
        HStack {
            CircularProgress(completed: completed, remaining: remaining, foregroundStyle: foregroundStyle)
            
            VStack {
                Text("\(completed) / \(completed + remaining)")
                    .font(.title)
                    
                Image(image)
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(height: 150)
    }
}



#Preview {
    ProgressCard(completed: 4, remaining: 6, foregroundStyle: .cyan, image: .momentum)
}
