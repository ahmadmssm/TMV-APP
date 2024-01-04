//
//  Binding+Extensions.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 06/11/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

/*
 Example:
 
 struct ContentView: View {
     @State private var rating = 0.0

     var body: some View {
         Slider(value: $rating.onChange(sliderChanged))
     }

     func sliderChanged(_ value: Double) {
         print("Rating changed to \(value)")
     }
 }
 */
extension Binding {
    
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
