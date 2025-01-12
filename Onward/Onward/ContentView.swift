//
//  ContentView.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/01/09.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationStack {
            DailyScreen()
        }
    }
   
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
