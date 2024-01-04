//
//  View+Extensions.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 25/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

extension View {
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}

extension View {
    
    func alert(isPresented: Binding<Bool>,
               title: String,
               message: String? = nil,
               dismissButton: Alert.Button? = nil) -> some View {
        alert(isPresented: isPresented) {
            Alert(title: Text(title),
                  message: {
                if let message = message { return Text(message) }
                else { return nil } }(),
                  dismissButton: dismissButton)
        }
    }
}
