//
//  EmptyStateViewModifier.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 06/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct EmptyStateViewModifier<EmptyView>: ViewModifier where EmptyView: View {
    
    var isEmpty: Bool
    let emptyView: () -> EmptyView
    
    func body(content: Content) -> some View {
        if isEmpty {
            emptyView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        else {
            content
        }
    }
}

extension View {
    func onEmpty<EmptyView>(_ isEmpty: Bool, emptyView: @escaping () -> EmptyView) -> some View where EmptyView: View {
        modifier(EmptyStateViewModifier(isEmpty: isEmpty, emptyView: emptyView))
    }
}
