//
//  PinchZoomViewModifier.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 09/10/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct PinchZoomViewModifier: ViewModifier {
    
    @Binding fileprivate var scale: CGFloat
    @Binding fileprivate var maxAllowedScale: CGFloat
    private var doubleTapGesture: some Gesture {
        TapGesture(count: 2).onEnded {
            if scale < maxAllowedScale / 2 {
                scale = maxAllowedScale
            } else {
                scale = 1.0
            }
        }
    }
    
    func body(content: Content) -> some View {
        ZoomableScrollView(scale: $scale, maxAllowedScale: $maxAllowedScale) {
            content
        }.gesture(doubleTapGesture)
    }
}

extension View {
    
    func addPinchZoomWith(scale: Binding<CGFloat>, maxAllowedScale: Binding<CGFloat>) -> some View  {
        modifier(PinchZoomViewModifier(scale: scale, maxAllowedScale: maxAllowedScale))
    }
}
