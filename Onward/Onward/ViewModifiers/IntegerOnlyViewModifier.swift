//
//  IntegerOnlyViewModifier.swift
//  Onward
//
//  Created by Sizwe Maluleke on 2025/02/01.
//

import SwiftUI
import Combine

struct IntegerOnlyViewModifier: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .keyboardType(.numberPad)
            .onReceive(Just(text)) { newValue in
                var numbers = "0123456789"
                let filtered = newValue.filter { numbers.contains($0) }
                if filtered != newValue {
                    self.text = filtered
                }
            }
            
    }
}

extension View {
    func integersOnly(_ text: Binding<String>) -> some View {
        self.modifier(IntegerOnlyViewModifier(text: text))
    }
}
    

