//
//  NavigateToViewModifier.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 10/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct NavigateToViewModifier<V: View>: ViewModifier {
    
    fileprivate let destinationView: V
    fileprivate let hideNavigationArrow: Bool
    
    func body(content: Content) -> some View {
        if hideNavigationArrow {
            ZStack {
                NavigationLink(destination: self.destinationView) {
                    EmptyView()
                }
                content
            }
        }
        else {
            NavigationLink(destination: self.destinationView) {
                content
            }
        }
    }
}

extension View {
    
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - hideNavigationArrow: Usefult when we want to remove the navigation link arrow from row list item, in this case we should pass true, otherwise false by defaut.
    func onTapNavigate<V: View>(to view: V, hideNavigationArrow: Bool = false) -> some View {
        modifier(NavigateToViewModifier(destinationView: view, hideNavigationArrow: hideNavigationArrow))
    }
}

extension View {
    
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, navigationTitle: String = "", when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarHidden(true)
                NavigationLink(
                    destination: view
                        .navigationTitle(navigationTitle)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarHidden(false),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

