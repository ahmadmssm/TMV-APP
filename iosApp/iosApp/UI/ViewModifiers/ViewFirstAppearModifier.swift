//
//  ViewDidLoadModifier.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 02/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct ViewFirstAppearModifier: ViewModifier {
    
    @State private var viewDidLoad = false
    private let action: (() -> Void)?
    
    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if viewDidLoad == false {
                viewDidLoad = true
                action?()
            }
        }
    }
}

extension View {
    
    func onFirstAppear(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewFirstAppearModifier(perform: action))
    }
}
