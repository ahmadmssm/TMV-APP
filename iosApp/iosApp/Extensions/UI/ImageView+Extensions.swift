//
//  ImageView+Extensions.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 21/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import NukeUI
import SwiftUI

extension Image {
    
    @MainActor static func fullSizeImageView(url: String) -> some View {
        LazyImage(url: URL(string: url)) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
                    .transition(.opacity.combined(with: .scale))
               } else if state.error != nil {
                   Image("image_placeholder")
               } else {
                   ProgressView()
               }
        }
        .priority(.high)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150, maxHeight: .infinity)
    }
    
    @MainActor static func halfAspectRatio(url: String) -> some View {
        LazyImage(url: URL(string: url)) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(0.5, contentMode: .fit)
                    .clipped()
                    .transition(.opacity.combined(with: .slide))
               } else if state.error != nil {
                   Image("image_placeholder")
               } else {
                   ProgressView()
               }
        }
        .priority(.high)
    }
    
    @MainActor static func createWithAspectFill(url: String) -> some View {
        LazyImage(url: URL(string: url)) { state in
            if let image = state.image {
                image
                    .resizable()
                    .clipped()
                    .transition(.opacity.combined(with: .slide))
               } else if state.error != nil {
                   Image("image_placeholder")
               } else {
                   ProgressView()
               }
        }
        .priority(.high)
    }
}
